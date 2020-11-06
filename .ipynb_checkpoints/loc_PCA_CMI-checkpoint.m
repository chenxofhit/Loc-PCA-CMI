close all;
clc;



hybrid = exist('datafile'); %default

if(~hybrid)

    if exist('result_loc_pcacmi')==0          
     system('mkdir result_loc_pcacmi');
    end
    datafile='/media/chenx/Program/Exp/bmrnet/db/Dream100/Dream100_Yeast.csv';
    goldenfile= '/media/chenx/Program/Exp/bmrnet/db/Dream100/Dream100_Yeast_golden.txt';
    clusterfile = '/media/chenx/Program/Exp/bmrnet/result_loc_pcacmi/Dream100_Yeast_cluster.mat';
    adjmatrixfile  = '/media/chenx/Program/Exp/bmrnet/result_loc_pcacmi/Dream100_Yeast_adjmatrixg.mat';
    order0=2;
    lamda=0.03;

else
    datafile
    goldenfile
    clusterfile
    adjmatrixfile
    order0
    lamda
end

x = importdata(datafile);

load(clusterfile);

gnum = size(x,2);
scoreIdxMatrix = zeros(gnum, gnum, gnum);

G = zeros(gnum,gnum);

data=x';

%% for each subnetwork
for i=1:size(adj,1)

   ntvcsIdx = adj(i,:);
   
   tvcsIdx = [i find(ntvcsIdx>0)];
   
   nvcsIdx =[1:length(tvcsIdx)];

   %if(length(tvcsIdx) <10) continue;end
   
   subdata = data(tvcsIdx,:);
   
   %lamda = 0.03; %order0 = 2;
   
   %% go  pca_cmi
   [Gb,Gval,order] = pca_cmi(subdata,lamda,order0) ;
   GvalSysmetric = triu(Gval,-1) + tril(Gval',0);
   
   tGval = zeros(gnum, gnum);
   for m =  1: length(nvcsIdx)
       for n = 1: length(nvcsIdx)
          tGval(tvcsIdx(nvcsIdx(m)), tvcsIdx(nvcsIdx(n))) = GvalSysmetric(m,n);
       end
   end
   
   scoreIdxMatrix(:,:,i) = tGval;
   
end

for i =1: gnum
    for j =1: gnum
        [ii,~,v] = find(scoreIdxMatrix(i,j,:));
        G(i,j) = mean(v);
    end
end

indices = find(isnan(G) == 1);
G(indices) = 0;

save(adjmatrixfile,'G');

if(hybrid)exit;
end;
