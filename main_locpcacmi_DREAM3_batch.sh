#/bin/bash

cd `pwd`

echo 'step1,dream3 datasets evaluating...'
bash tpl-generator.sh main_locpcacmi_DREAM3_Ecoli_tpl
bash tpl-generator.sh main_locpcacmi_DREAM3_Yeast_tpl

bash ./main_locpcacmi_DREAM3_Yeast_tpl10.sh
bash ./main_locpcacmi_DREAM3_Yeast_tpl50.sh
bash ./main_locpcacmi_DREAM3_Yeast_tpl100.sh

bash ./main_locpcacmi_DREAM3_Ecoli_tpl10.sh
bash ./main_locpcacmi_DREAM3_Ecoli_tpl50.sh
bash ./main_locpcacmi_DREAM3_Ecoli_tpl100.sh


# echo 'step2,gnw silico datasets evaluating...'
# bash tpl-generator_gnw.sh main_locpcacmi_gnw_Ecoli500-tpl

# bash ./main_locpcacmi_gnw_Ecoli500-tpl500-1.sh
# bash ./main_locpcacmi_gnw_Ecoli500-tpl500-2.sh
# bash ./main_locpcacmi_gnw_Ecoli500-tpl500-3.sh
# bash ./main_locpcacmi_gnw_Ecoli500-tpl500-4.sh
# bash ./main_locpcacmi_gnw_Ecoli500-tpl500-5.sh

echo 'step3,cleaning temporary files...'
rm -rf  ./main_locpcacmi_DREAM3_Yeast10.sh
rm -rf  ./main_locpcacmi_DREAM3_Yeast50.sh
rm -rf  ./main_locpcacmi_DREAM3_Yeast100.sh

rm -rf  ./main_locpcacmi_DREAM3_Ecoli10.sh
rm -rf  ./main_locpcacmi_DREAM3_Ecoli50.sh
rm -rf  ./main_locpcacmi_DREAM3_Ecoli100.sh

# rm -rf ./main_locpcacmi_gnw_Ecoli500-tpl500-1.sh
# rm -rf ./main_locpcacmi_gnw_Ecoli500-tpl500-2.sh
# rm -rf ./main_locpcacmi_gnw_Ecoli500-tpl500-3.sh
# rm -rf ./main_locpcacmi_gnw_Ecoli500-tpl500-4.sh
# rm -rf ./main_locpcacmi_gnw_Ecoli500-tpl500-5.sh

echo 'step4,Done!'