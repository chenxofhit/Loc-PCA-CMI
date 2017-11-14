#/bin/bash

curdir=`pwd`

datafile="$curdir/../db/Dream10/Dream10_Yeast.csv"
goldenfile="$curdir/../db/Dream10/Dream10_Yeast_golden.txt"
clusterfile="$curdir/../result_loc_pcacmi/Dream10_Yeast_cluster.mat"

pcacmi_adjmatrix="$curdir/../result_pca_cmi/Dream10_Yeast_adjmatrixg.mat"
pcapmi_adjmatrix="$curdir/../result_pca_pmi/Dream10_Yeast_adjmatrixg.mat"

loc_pca_cmi_adjmatrix="$curdir/../result_loc_pcacmi/Dream10_Yeast_adjmatrixg.mat"
loc_pca_pmi_adjmatrix="$curdir/../result_loc_pcapmi/Dream10_Yeast_adjmatrixg.mat"

prfile="$curdir/Dream10_Yeast_AUPR_AUROC.png"

summaryfile="$curdir/Dream10_Yeast_AUPR_AUROC.txt"

Rscript loc-PCA-CMI_comparison_core.R $datafile $goldenfile $clusterfile $pcacmi_adjmatrix $pcapmi_adjmatrix $loc_pca_cmi_adjmatrix $loc_pca_pmi_adjmatrix $prfile >> $summaryfile