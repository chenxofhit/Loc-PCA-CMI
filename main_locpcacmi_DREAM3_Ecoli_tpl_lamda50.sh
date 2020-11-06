#/bin/bash
#author:chenxofhit@gmail.com 
#since 2020-12-02

resdir_locpcacmi="result_loc_pcacmi_lamda"
mkdir -p $resdir_locpcacmi

resdir_locpcapmi="result_loc_pcapmi_lamda"
mkdir -p $resdir_locpcapmi

resdir_cmi="result_pca_cmi_lamda"
mkdir -p $resdir_cmi

resdir_pmi="result_pca_pmi_lamda"
mkdir -p $resdir_pmi

curdir=`pwd`

#input
datafile="$curdir/db/Dream50/Dream50_Ecoli.csv"
goldenfile="$curdir/db/Dream50/Dream50_Ecoli_golden.txt"
clusterfile="$curdir/$resdir_locpcacmi/Dream50_Ecoli_cluster.mat"

#output
loc_pcacmi_adjmatrix="$curdir/$resdir_locpcacmi/Dream50_Ecoli_adjmatrixg.mat"
loc_pcapmi_adjmatrix="$curdir/$resdir_locpcapmi/Dream50_Ecoli_adjmatrixg.mat"

pca_cmi_adjmatrix="$curdir/$resdir_cmi/Dream50_Ecoli_adjmatrixg.mat"
pca_pmi_adjmatrix="$curdir/$resdir_pmi/Dream50_Ecoli_adjmatrixg.mat"

#res 
loc_pcacmi_resfile="$curdir/$resdir_locpcacmi/Dream50_Ecoli.res"
loc_pcapmi_resfile="$curdir/$resdir_locpcapmi/Dream50_Ecoli.res"

pca_cmi_resfile="$curdir/$resdir_cmi/Dream50_Ecoli.res"
pca_pmi_resfile="$curdir/$resdir_pmi/Dream50_Ecoli.res"


lamdas=(0.01 0.02 0.03 0.05 0.1 0.15 0.2)
order0=2
for lamda in ${lamdas[@]};
do
echo '#########PCA_CMI######## starts...with source:'$datafile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';adjmatrixfile='$pca_cmi_adjmatrix';order0=$order0;lamda=$lamda;pca_cmi_sh"
Rscript myeval.R  $datafile $goldenfile $pca_cmi_adjmatrix>> $pca_cmi_resfile

echo '#########PCA_PMI######## starts...with source:'$datafile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';adjmatrixfile='$pca_pmi_adjmatrix';order0=$order0;lamda=$lamda;pca_pmi_sh"
Rscript myeval.R  $datafile $goldenfile $pca_pmi_adjmatrix>> $pca_pmi_resfile

echo '#########loc_PCA_CMI######## starts... with source:'$datafile
Rscript loc-PCA-CMI_pc_cluster.R $datafile $goldenfile $clusterfile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';clusterfile='$clusterfile';adjmatrixfile='$loc_pcacmi_adjmatrix';order0=$order0;lamda=$lamda;loc_PCA_CMI"
Rscript myeval.R  $datafile $goldenfile $loc_pcacmi_adjmatrix>> $loc_pcacmi_resfile

echo '#########loc_PCA_PMI######## starts... with source:'$datafile
Rscript loc-PCA-CMI_pc_cluster.R $datafile $goldenfile $clusterfile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';clusterfile='$clusterfile';adjmatrixfile='$loc_pcapmi_adjmatrix';order0=$order0;lamda=$lamda;loc_PCA_PMI"
Rscript myeval.R  $datafile $goldenfile $loc_pcapmi_adjmatrix>> $loc_pcapmi_resfile

done

echo $datafile" methods comparision end..."
exit