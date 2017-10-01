function [G,Gval,l]=pca_pmi(data,lambda,l0)  
% PCA_PMI is an function to construct the Gene Expression Network by using
% Pathing-consist Algorithm with PMI.
% G=PCA_PMI(data,lambda) "data" is a n*T matrix, with n genes and T samples,
% the network of the n genes will be constructed. "lambda" is a threshold
% of reducing edges.
% G=PCA_PMI(data,lambda,l0) "l0" is a positive integer, if the
% algorithm is processing in the order larger than "l0", the algorithm
% will stop reducing the edge and return the network.
% G=KPCA_PMI(...) "G" returns a binary lower triangle square matrix, the
% element "1" means there is an edge in the matching place, while the
% element "0" means there is no edge in the matching place in the network.
% [G,GVAL]=PCA_PMI(...) "Gval" returns a lower triangle square matrix,
% every entry in "Gval" represents the strength of the matching edge
% [G,GVAL,l]=PCA_PMI(...) "l" returns a final order where the algorithm processes

n_gene=size(data,1);
G=ones(n_gene,n_gene);
G=tril(G,-1)'; 
G=G+G';
Gval=G;
l=-1;t=0;
while t==0
     l=l+1;
     if nargin==3
       if l>l0
           G=tril(G,-1)';     Gval=tril(Gval,-1)';  
           l=l-1; % The value of l is the last order of pc algorith 
           return
       end
     end
    [G,Gval,t]=edgereduce(G,Gval,l,data,t,lambda);
 
     if t==0
          % disp('No edge is reduce! Algorithm  finished!');%For Debugging
          break;
     else 
          t=0;
     end
end
  
   G=tril(G,-1)';     Gval=tril(Gval,-1)';  
   l=l-1; % The value of l is the last order of pc algorith 
end

%% edgereduce is pcalg
function [G,Gval,t]=edgereduce(G,Gval,l,data,t,lambda)
%[nrow,ncol]=find(G~=0);%For debugging

if l==0
    for i=1:size(G,1)-1
        for j=i+1:size(G,1)
            if G(i,j)~=0
                cmiv=cmi(data(i,:),data(j,:));
                Gval(i,j)=cmiv;  Gval(j,i)=cmiv;
                if cmiv<lambda
                    G(i,j)=0;G(j,i)=0;
                end
            end
        end
    end
          t=t+1;
else
  for i=1:size(G,1)-1
      for j=i+1:size(G,1)
          if G(i,j)~=0
              i;%For debugging
              j;%For debugging
              adj=[] ;%For debugging
              for k=1:size(G,1)
                  if G(i,k)~=0 && G(j,k)~=0
                      adj=[adj,k] ;
                  end
              end
              if size(adj,2)>=l
                   combntnslist=nchoosek(adj,l);
                   combntnsrow=size(combntnslist,1);   
                   cmiv=0;
                    v1=data(i,:);v2=data(j,:);
                   for k=1:combntnsrow   
                    vcs=data(combntnslist(k,:),:);
                     a=cmi(v1,v2,vcs) ;
                     cmiv=max(cmiv,a);
                   end
                   cmiv;%For debugging
                      Gval(i,j)=cmiv; Gval(j,i)=cmiv;
                      if cmiv<lambda
                          G(i,j)=0; G(j,i)=0;
                      end              
                           t=t+1;
              end
          end
                      
      end
  end             
end
end

%% compute partial mutual information of x and y
function cmiv=cmi(v1,v2,vcs)
 if  nargin==2
        c1=det(cov(v1));
        c2=det(cov(v2));
        c3=det(cov(v1,v2));
        cmiv=0.5*log(c1*c2/c3); 
     elseif  nargin==3
       n1 = size(vcs,1);
       n = n1 +2;

       Cov1 = var(v1);
       Cov2 = var(v2);
       Covm = cov([v1;v2;vcs]');
       Covm1 = cov(vcs');
       Covm2 =cov([v1;vcs]');
       Covm3 = cov([v2;vcs]');

       InvCov1 = 1/Cov1;
       InvCov2 = 1/Cov2;
       InvCovm = inv(Covm);
       InvCovm1 = inv(Covm1);
       InvCovm2 = inv(Covm2);
       InvCovm3 = inv(Covm3);

       C11 = -InvCovm(1,2)*(1/(InvCovm(2,2)-InvCovm3(1,1)+InvCov2))*InvCovm(1,2)+InvCovm(1,1);
       C12 = 0;
       C13 = -InvCovm(1,2)*(1/(InvCovm(2,2)-InvCovm3(1,1)+InvCov2))*(InvCovm(2,3:2+n1)-InvCovm3(1,2:1+n1))+InvCovm(1,3:2+n1);
       C23 = -InvCovm(1,2)*(1/(InvCovm(1,1)-InvCovm2(1,1)+InvCov1))*(InvCovm(1,3:2+n1)-InvCovm2(1,2:1+n1))+InvCovm(2,3:2+n1);
       C22 = -InvCovm(1,2)*(1/(InvCovm(1,1)-InvCovm2(1,1)+InvCov1))*InvCovm(1,2)+InvCovm(2,2);
       C33 = -(InvCovm(2,3:2+n1)-InvCovm3(1,2:1+n1))'*(1/(InvCovm(2,2)-InvCovm3(1,1)+InvCov2))*(InvCovm(2,3:2+n1)-InvCovm3(1,2:1+n1))-(InvCovm(1,3:2+n1)-InvCovm2(1,2:1+n1))'*(1/(InvCovm(1,1)-InvCovm2(1,1)+InvCov1))*(InvCovm(1,3:2+n1)-InvCovm2(1,2:1+n1))+(InvCovm(3:2+n1,3:2+n1)-InvCovm3(2:1+n1,2:1+n1))+(InvCovm(3:2+n1,3:2+n1)-InvCovm2(2:1+n1,2:1+n1))+InvCovm1;
       InvC = [[C11,C12,C13];[C12,C22,C23];[[C13',C23'],C33]];
       % C = inv(InvC);  

       C0 = (det(Covm)*det(Covm1)/(det(Covm2)*det(Covm3)))*Cov1*Cov2*(InvCovm(2,2)-InvCovm3(1,1)+InvCov2)*(InvCovm(1,1)-InvCovm2(1,1)+InvCov1);
       cmiv = 0.5 * (trace(InvC*Covm)+log(C0)-n); 
       
 end
    % cmiv=abs(cmiv);
      if  cmiv==inf 
            cmiv=0;
     end
end
