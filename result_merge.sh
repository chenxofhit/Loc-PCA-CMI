#!/bin/bash

#merge results from sub folders in three folders
#eg.result_loc_pcacmi/result_pca_cmi/result_pca_pmi


#methods name!!!
loc_pcacmi="result_loc_pcacmi"
pca_cmi="result_pca_cmi"
pca_pmi="result_pca_pmi"

#res file name!!!
prroc[1]="Dream10_Ecoli.res"
prroc[2]="Dream50_Ecoli.res"
prroc[3]="Dream100_Ecoli.res"

prroc[4]="Dream10_Yeast.res"
prroc[5]="Dream50_Yeast.res"
prroc[6]="Dream100_Yeast.res"


rptfile=`pwd`"/result_merge_final.res"

echo $loc_pcacmi>>$rptfile
tail -n 2 `pwd`"/"$loc_pcacmi"/"${prroc[1]} >> $rptfile
echo $pca_cmi>>$rptfile
tail -n 2 `pwd`"/"$pca_cmi"/"${prroc[1]} >> $rptfile
echo $pca_pmi>>$rptfile
tail -n 2 `pwd`"/"$pca_pmi"/"${prroc[1]} >> $rptfile

echo $loc_pcacmi>>$rptfile
tail -n 2 `pwd`"/"$loc_pcacmi"/"${prroc[2]} >> $rptfile
echo $pca_cmi>>$rptfile
tail -n 2 `pwd`"/"$pca_cmi"/"${prroc[2]} >> $rptfile
echo $pca_pmi>>$rptfile
tail -n 2 `pwd`"/"$pca_pmi"/"${prroc[2]} >> $rptfile

echo $loc_pcacmi>>$rptfile
tail -n 2 `pwd`"/"$loc_pcacmi"/"${prroc[3]} >> $rptfile
echo $pca_cmi>>$rptfile
tail -n 2 `pwd`"/"$pca_cmi"/"${prroc[3]} >> $rptfile
echo $pca_pmi>>$rptfile
tail -n 2 `pwd`"/"$pca_pmi"/"${prroc[3]} >> $rptfile

echo $loc_pcacmi>>$rptfile
tail -n 2 `pwd`"/"$loc_pcacmi"/"${prroc[4]} >> $rptfile
echo $pca_cmi>>$rptfile
tail -n 2 `pwd`"/"$pca_cmi"/"${prroc[4]} >> $rptfile
echo $pca_pmi>>$rptfile
tail -n 2 `pwd`"/"$pca_pmi"/"${prroc[4]} >> $rptfile

echo $loc_pcacmi>>$rptfile
tail -n 2 `pwd`"/"$loc_pcacmi"/"${prroc[5]} >> $rptfile
echo $pca_cmi>>$rptfile
tail -n 2 `pwd`"/"$pca_cmi"/"${prroc[5]} >> $rptfile
echo $pca_pmi>>$rptfile
tail -n 2 `pwd`"/"$pca_pmi"/"${prroc[5]} >> $rptfile

echo $loc_pcacmi>>$rptfile
tail -n 2 `pwd`"/"$loc_pcacmi"/"${prroc[6]} >> $rptfile
echo $pca_cmi>>$rptfile
tail -n 2 `pwd`"/"$pca_cmi"/"${prroc[6]} >> $rptfile
echo $pca_pmi>>$rptfile
tail -n 2 `pwd`"/"$pca_pmi"/"${prroc[6]} >> $rptfile


echo "Updated at!"`date`>>$rptfile