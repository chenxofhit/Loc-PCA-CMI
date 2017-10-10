#/bin/bash

curdir=`pwd`


cd `pwd`

echo 'step1,dream3 datasets comparison start...'
bash tpl-generator.sh loc-PCA-CMI_comparison.Ecoli_tpl
bash tpl-generator.sh loc-PCA-CMI_comparison.Yeast_tpl

bash ./loc-PCA-CMI_comparison.Ecoli_tpl10.sh
bash ./loc-PCA-CMI_comparison.Ecoli_tpl50.sh
bash ./loc-PCA-CMI_comparison.Ecoli_tpl100.sh

bash ./loc-PCA-CMI_comparison.Yeast_tpl10.sh
bash ./loc-PCA-CMI_comparison.Yeast_tpl50.sh
bash ./loc-PCA-CMI_comparison.Yeast_tpl100.sh

echo 'step2,cleaning temperary files...'
rm -rf  ./loc-PCA-CMI_comparison.Ecoli_tpl10.sh
rm -rf  ./loc-PCA-CMI_comparison.Ecoli_tpl50.sh
rm -rf  ./loc-PCA-CMI_comparison.Ecoli_tpl100.sh

rm -rf  ./loc-PCA-CMI_comparison.Yeast_tpl10.sh
rm -rf  ./loc-PCA-CMI_comparison.Yeast_tpl50.sh
rm -rf  ./loc-PCA-CMI_comparison.Yeast_tpl100.sh

echo 'step3,dream3 datasets comparison end...'