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
datafile="$curdir/db/gnw/Ecoli-size500-1/Ecoli-500-1_knockouts.csv"
goldenfile="$curdir/db/gnw/Ecoli-size500-1/Ecoli-500-1_golden.txt"
clusterfile="$curdir/$resdir/Ecoli-500-1_cluster.mat"

#output
zeropc_adjmatrix="$curdir/$resdir/Ecoli-500-1_adjmatrixg.mat"
pca_cmi_adjmatrix="$curdir/$resdir_cmi/Ecoli-500-1_adjmatrixg.mat"
pca_pmi_adjmatrix="$curdir/$resdir_pmi/Ecoli-500-1_adjmatrixg.mat"

#res 
zeropc_resfile="$curdir/$resdir/Ecoli-500-1.res"
pca_cmi_resfile="$curdir/$resdir_cmi/gnw_Ecoli-500-1.res"
pca_pmi_resfile="$curdir/$resdir_pmi/gnw_Ecoli-500-1.res"

maxTimes=1
for ((i=1; i<=$maxTimes; i++))
do
echo '#########PCA_CMI\PCA_PMI######## starts...with source:'$datafile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';adjmatrixfile='$pca_cmi_adjmatrix';pca_cmi_sh"
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';adjmatrixfile='$pca_pmi_adjmatrix';pca_pmi_sh"

Rscript myeval.R  $datafile $goldenfile $pca_cmi_adjmatrix>> $pca_cmi_resfile
Rscript myeval.R  $datafile $goldenfile $pca_pmi_adjmatrix>> $pca_pmi_resfile

echo '#########loc_PCA_CMI######## starts... with source:'$datafile

Rscript cluster_zeropc.R  $datafile $goldenfile $clusterfile
matlab -nosplash -nodisplay -r "datafile='$datafile';goldenfile='$goldenfile';clusterfile='$clusterfile';adjmatrixfile='$zeropc_adjmatrix';pca_cmi_zeropc"
Rscript myeval.R  $datafile $goldenfile $zeropc_adjmatrix>> $zeropc_resfile
done

echo $datafile" process end!"

exit