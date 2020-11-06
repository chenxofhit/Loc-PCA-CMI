#!/bin/bash
#author:chenxofhit@gmail.com 
#since 2017-07-07

resdir_locpcacmi="result_loc_pcacmi"
mkdir -p $resdir_locpcacmi

resdir_locpcapmi="result_loc_pcapmi"
mkdir -p $resdir_locpcapmi

resdir_cmi="result_pca_cmi"
mkdir -p $resdir_cmi

resdir_pmi="result_pca_pmi"
mkdir -p $resdir_pmi

curdir=`pwd`

#input
datafile="$curdir/db/Dream10/Dream10_Yeast.csv"
goldenfile="$curdir/db/Dream10/Dream10_Yeast_golden.txt"
clusterfile="$curdir/$resdir_locpcacmi/Dream10_Yeast_cluster.mat"

#output
loc_pcacmi_adjmatrix="$curdir/$resdir_locpcacmi/Dream10_Yeast_adjmatrixg.mat"
loc_pcapmi_adjmatrix="$curdir/$resdir_locpcapmi/Dream10_Yeast_adjmatrixg.mat"

pca_cmi_adjmatrix="$curdir/$resdir_cmi/Dream10_Yeast_adjmatrixg.mat"
pca_pmi_adjmatrix="$curdir/$resdir_pmi/Dream10_Yeast_adjmatrixg.mat"

#res 
loc_pcacmi_resfile="$curdir/$resdir_locpcacmi/Dream10_Yeast.res"
loc_pcapmi_resfile="$curdir/$resdir_locpcapmi/Dream10_Yeast.res"

pca_cmi_resfile="$curdir/$resdir_cmi/Dream10_Yeast.res"
pca_pmi_resfile="$curdir/$resdir_pmi/Dream10_Yeast.res"

maxTimes=1
for ((i=1; i<=$maxTimes; i++))
do
echo '#########PCA_CMI######## starts...with source:'$datafile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';adjmatrixfile='$pca_cmi_adjmatrix';pca_cmi_sh"
Rscript myeval.R  $datafile $goldenfile $pca_cmi_adjmatrix>> $pca_cmi_resfile


echo '#########PCA_PMI######## starts...with source:'$datafile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';adjmatrixfile='$pca_pmi_adjmatrix';pca_pmi_sh"
Rscript myeval.R  $datafile $goldenfile $pca_pmi_adjmatrix>> $pca_pmi_resfile

echo '#########loc_PCA_CMI######## starts... with source:'$datafile
Rscript loc-PCA-CMI_pc_cluster.R $datafile $goldenfile $clusterfile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';clusterfile='$clusterfile';adjmatrixfile='$loc_pcacmi_adjmatrix';loc_PCA_CMI"
Rscript myeval.R  $datafile $goldenfile $loc_pcacmi_adjmatrix>> $loc_pcacmi_resfile

echo '#########loc_PCA_PMI######## starts... with source:'$datafile
Rscript loc-PCA-CMI_pc_cluster.R $datafile $goldenfile $clusterfile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';clusterfile='$clusterfile';adjmatrixfile='$loc_pcapmi_adjmatrix';loc_PCA_PMI"
Rscript myeval.R  $datafile $goldenfile $loc_pcapmi_adjmatrix>> $loc_pcapmi_resfile

done

echo $datafile" methods comparision end..."
exit