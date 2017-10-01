close all;
clc;

tic;

hybrid=exist('datafile'); %default

if exist('result_pca_pmi')==0          
    system('mkdir result_pca_pmi');
end


if(~hybrid)
  datafile  = [pwd '/db/Dream50/Dream50_Yeast.csv'];
  goldenfile  =  [pwd '/db/Dream50/Dream50_Yeast_golden.txt'];
  adjmatrixfile  =  [pwd '/result_pca_pmi/Dream50_Yeast_adjmatrixg.mat'];
else
  datafile
  goldenfile
  adjmatrixfile
end

%% read database
data = importdata(datafile);

%% parameter of pca-cmi
lamda = 0.03; order0=2;

%% go  pca_pmi
[Gb,Gval,order] = pca_pmi(data',lamda,order0) ;
G=triu(Gval,-1)+tril(Gval',0);

toc;

save(adjmatrixfile,'G');

if(hybrid)exit;
end;
