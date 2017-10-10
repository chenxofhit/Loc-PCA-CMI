# Loc-PCA-CMI

Loc-PCA-CMI is a novel method of gene regulatory network structure inference on gene knock-out expression data,which first identify Local Overlapped gene Clusters,  and then in conjunction with PCA-CMI method each local cluster structure is refined.

## System Environment
Ubuntu/Linux Bash, Matlab 2015b, R 3.3.1 (with package "readr", "R.matlab", "Matrix" , "RLowPC", "minet", "igraph","gtools").

## Running Step

Step 1,  To run the complete experiment with only one bash command (sudo privillege perhaps needed according to your running environment):
```{bash}
bash main_locpcacmi_DREAM3_batch.sh
```

The command will generate four sub folders as result_loc_pcacmi, result_loc_pcapmi, result_pca_cmi and result_pca_pmi and the result including AUPR and AUROC will be output to the folders.
For a more visualized summary you may use the below command to collect the  results in comparison folder:
```{bash}

bash ./comparison/result_merge.sh
```
and the summary will be output to result_merge_final.res in the same folder.

Step 2, For comparison with other methods including ARACNE, MRNET, PCA-PMI, PCA-CMI and loc-PCA-PMI you can run loc-PCA-CMI_comparison.R in comparison folder in your R IDE (eg. RStudio) with different input files configuration in the code.

Noticed that except above mentioned  main_locpcacmi_DREAM3_batch.sh , result_merge.sh, loc-PCA-CMI_comparison.R, if you know the code quite very well any change is discouraged.

Any question, please do not hesitate to  contact me with following address with bash command for decryption:

```{bash} 
echo "Y2hlbnhvZmhpdEBnbWFpbC5jb20K"|base64 -d
```
or [submit issue](https://github.com/chenxofhit/Loc-PCA-CMI/issues) in the repository directly.
