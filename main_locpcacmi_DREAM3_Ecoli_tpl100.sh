#!/bin/bash
#author:chenxofhit@gmail.com 
#since 2017-07-07

resdir="result_loc_pcacmi"
mkdir -p $resdir

resdir_cmi="result_pca_cmi"
mkdir -p $resdir_cmi

resdir_pmi="result_pca_pmi"
mkdir -p $resdir_pmi

curdir=`pwd`

#input
datafile="$curdir/db/Dream100/Dream100_Ecoli.csv"
goldenfile="$curdir/db/Dream100/Dream100_Ecoli_golden.txt"
clusterfile="$curdir/$resdir/Dream100_Ecoli_cluster.mat"

#output
zeropc_adjmatrix="$curdir/$resdir/Dream100_Ecoli_adjmatrixg.mat"
pca_cmi_adjmatrix="$curdir/$resdir_cmi/Dream100_Ecoli_adjmatrixg.mat"
pca_pmi_adjmatrix="$curdir/$resdir_pmi/Dream100_Ecoli_adjmatrixg.mat"

#res 
zeropc_resfile="$curdir/$resdir/Dream100_Ecoli.res"
pca_cmi_resfile="$curdir/$resdir_cmi/Dream100_Ecoli.res"
pca_pmi_resfile="$curdir/$resdir_pmi/Dream100_Ecoli.res"

maxTimes=1
for ((i=1; i<=$maxTimes; i++))
do
echo '#########PCA_CMI\PCA_PMI######## starts...with source:'$datafile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';adjmatrixfile='$pca_cmi_adjmatrix';pca_cmi_sh"
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';adjmatrixfile='$pca_pmi_adjmatrix';pca_pmi_sh"

Rscript myeval.R  $datafile $goldenfile $pca_cmi_adjmatrix>> $pca_cmi_resfile
Rscript myeval.R  $datafile $goldenfile $pca_pmi_adjmatrix>> $pca_pmi_resfile

echo '#########loc_PCA_CMI######## starts... with source:'$datafile

Rscript loc-PCA-CMI_pc_cluster.R $datafile $goldenfile $clusterfile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';clusterfile='$clusterfile';adjmatrixfile='$zeropc_adjmatrix';loc_PCA_CMI"
Rscript myeval.R  $datafile $goldenfile $zeropc_adjmatrix>> $zeropc_resfile

done

echo $datafile" methods comparision end..."
exit