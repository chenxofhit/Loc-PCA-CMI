# Loc-PCA-CMI

Implementation for our paper [[Link]](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8660530).

Loc-PCA-CMI is a novel method of gene regulatory network structure inference on gene knock-out expression data,which first identify Local Overlapped gene Clusters,  and then in conjunction with PCA-CMI method each local cluster structure is refined.

## System Environment
Ubuntu/Linux Bash, Matlab 2015b, R 3.3.1 (with package "readr", "R.matlab", "Matrix" , "RLowPC", "minet", "igraph","gtools").

## Running Step

Step 1,  To run the complete experiment with only one bash command in the current folder (sudo privillege perhaps needed according to your running environment):
```{bash}
cd ./ && bash ./main_locpcacmi_DREAM3_batch.sh
```

The command will generate four sub folders as result_loc_pcacmi, result_loc_pcapmi, result_pca_cmi and result_pca_pmi and the result including AUPR and AUROC will be output to the folders. For a more visualized summary you may use the below command to collect the  results:
```{bash}
cd ./ && bash ./result_merge.sh
```
and the summary will be output to result_merge_final.res .

Step 2, For comparison with more methods including ARACNE, MRNET, PCA-PMI, PCA-CMI and loc-PCA-PMI as in the paper stated,  it is encouraged to run the following bash command in the folder comparison:
```{bash}
cd ./comparison && bash ./loc-PCA-CMI_comparison.batch.sh 
```

Above command will generate both txt files and image files with AUPR and AUROC details in the same folder. 

Step 3 (Addtional), In order to to validate the parameter order0 in the PCA alogrithm,  main_locpcacmi_DREAM3_Ecoli_tpl_k.sh and main_locpcacmi_DREAM3_Yeast_tpl_k.sh are applied and result is output to folder result_*_k.

Any question, please do not hesitate to  contact me with following address with bash command for decryption:

```{bash} 
echo "Y2hlbnhvZmhpdEBnbWFpbC5jb20K"|base64 -d
```
or [submit issue](https://github.com/chenxofhit/Loc-PCA-CMI/issues) in the repository directly.

## Citation

Please cite the following paper in your publications if it helps your research:

<div class="highlight-none"><div class="highlight"><pre>
@ARTICLE{8660530, 
author={X. {Chen} and M. {Li} and R. {Zheng} and S. {Zhao} and F. {Wu} and Y. {Li} and J. {Wang}}, 
journal={Tsinghua Science and Technology}, 
title={A novel method of gene regulatory network structure inference from gene knock-out expression data}, 
year={2019}, 
volume={24}, 
number={4}, 
pages={446-455}, 
keywords={gene regulatory networks;network inference;path consistency algorithm}, 
doi={10.26599/TST.2018.9010097}, 
ISSN={1007-0214}, 
month={Aug},}
</pre></div>
