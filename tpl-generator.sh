#!/bin/bash
#author:chenxofhit@gmail.com 
#since 2017-04-27
#######################################################################################
#The script is to make use of `$1`.sh as template to produce  subbash shell
#to run experiments on the server batchly
#######################################################################################

echo $1' sub networks generator start'

#tpl='main_bfgrn_mrnetb'
tpl=$1

templatebash=$tpl'.sh'
ext=${templatebash##*.} 

subbash[0]="10"
subbash[1]="50"
subbash[2]="100"

sed 's/10/'${subbash[0]}'/g' $templatebash > $tpl${subbash[0]}"."$ext
sed 's/10/'${subbash[1]}'/g' $templatebash > $tpl${subbash[1]}"."$ext
sed 's/10/'${subbash[2]}'/g' $templatebash > $tpl${subbash[2]}"."$ext

echo $1' sub networks generator end'