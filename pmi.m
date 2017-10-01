function [ I, pvalue, H0 ] = pmi( x,y,z,n,R )
% I=PMI(X,Y,Z) compute the pmi value of "x" "y" conditioned on "z"
% I=PMI(X,Y,Z,N) "n" is  the number of bins to estimate the probability of
% P(x,y,z), the default setting of "n" is 10
% I=PMI(X,Y,Z,N,R) "R" is the number of repeat times of Null Hypothesis to
% calculate the P-value of PMI, the default setting of "n" is 100
% [ I, PVALUE ] = PMI(...) "pvalue" return the P-value of PMI by repeating
% calulate the PMI in the Null Hypothesis situation
% [ I, PVALUE , H0] = PMI(...) "H0" treturns all of the PMI values calulated 
% in the Null Hypothesis situation
%2nd Edition, P value and Null Hypothesis

k=size(x,1);
if ~exist('n') || nargin<=3 || isempty(n)
    n=floor((k.*exp(1))^(1/4));
elseif ~exist('R') || nargin<=4 || isempty(R)
    R=100;
end % input checking

if numel(n)==1
    Nxyz=hist4([x,y,z],[n,n,n])+0.001;
    n=[n,n,n];
elseif numel(n)==3
    Nxyz=hist4([x,y,z],n)+0.001;
else
    error(message('stats:cmi:Number of N must be 1 or 3.'));
end


Pxyz=Nxyz./sum(Nxyz(:));   %P(x,y,z)
I=information(Pxyz);

if nargout>=2
    Nz=sum(sum(Nxyz,2),1);
    Nxz=sum(Nxyz,2);
    Nyz=sum(Nxyz,1);
    I0=nan(R,1);
    parfor j=1:R
        Nxyz_r=arrayfun(@(i)hist3([randsample(n(1),Nz(i),1,Nxz(:,:,i)) randsample(n(2),Nz(i),1,Nyz(:,:,i))],...
            {1:n(1),1:n(2)}),...
            reshape(1:n(3),1,1,[]),'UniformOutput',0);
        Nxyz_r=cell2mat(Nxyz_r);
        I0(j)=information(Nxyz_r./k);
    end
    H0=I0;
    pvalue=sum(H0>I)./R;
end
end

function I=information(Pxyz)
n=size(Pxyz);
Pxz=sum(Pxyz,2);   %P(x,z)
Px=sum(Pxz,3);  %P(x)
Pyz=sum(Pxyz,1);    %P(y,z)
Py=sum(Pyz,3);  %P(y)
Pz=sum(sum(Pxyz));  %P(z)
%%

Px_yz=cell2mat(arrayfun(@(i)Pxyz(i,:,:)./Pyz,[1:n(1)]','UniformOutput',0));
Px_z=cell2mat(arrayfun(@(i)Pxz(:,:,i)./Pz(i),reshape(1:n(3),1,1,[]),'UniformOutput',0));
Px_z=repmat(Px_z,[1 n(2) 1]);
Px_yz(isnan(Px_yz))=0;
Sy_Px_yzPy=sum(cell2mat(arrayfun(@(i)Px_yz(:,i,:).*Py(i),1:n(2),'UniformOutput',0)),2);

%%
Py_xz=cell2mat(arrayfun(@(i)Pxyz(:,i,:)./Pxz,1:n(2),'UniformOutput',0));
Py_z=cell2mat(arrayfun(@(i)Pyz(:,:,i)./Pz(i),reshape(1:n(3),1,1,[]),'UniformOutput',0));
Py_z=repmat(Py_z,[n(1) 1 1]);
Py_xz(isnan(Py_xz))=0;
Sx_Py_xzPx=sum(cell2mat(arrayfun(@(i)Py_xz(i,:,:).*Px(i),[1:n(1)]','UniformOutput',0)),1);
%%
Plog=cell2mat(arrayfun(@(i)(Pxyz(:,:,i)./Pz(i)./(Sy_Px_yzPy(:,:,i)*Sx_Py_xzPx(:,:,i))),reshape(1:n(3),[1 1 n(3)]),'UniformOutput',0));
E=Pxyz.*log(Plog);
E(Pxyz==0)=0;
I=sum(E(:));

end
