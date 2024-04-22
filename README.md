
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BiologyDB

<!-- badges: start -->
<!-- badges: end -->

> 为什么做这件事？
> 初衷是用于做基因的注释，后来发现有些数据库多多少少有些问题，比如基因名错了、基因ID过时了等等，为了方便重复使用数据库，所以将常用的数据库整理好了，方便重复调用。

## 安装

``` r
library(devtools)
install_github("fentouxungui/BiologyDB")
```

## 数据

``` r
library(BiologyDB)
d <- data(package = "BiologyDB")
d$results[,"Item"]
#>  [1] "AnimalTFDB_Human_TF"                                              
#>  [2] "AnimalTFDB_Human_TFCofactors"                                     
#>  [3] "AnimalTFDB_Mouse_TF"                                              
#>  [4] "AnimalTFDB_Mouse_TFCofactors"                                     
#>  [5] "CellChat_Human_LigandReceptorsInteractions"                       
#>  [6] "CellChat_Human_Ligands"                                           
#>  [7] "CellChat_Human_Receptors"                                         
#>  [8] "CellChat_Mouse_LigandReceptorsInteractions"                       
#>  [9] "CellChat_Mouse_Ligands"                                           
#> [10] "CellChat_Mouse_Receptors"                                         
#> [11] "CellPhoneDB_Human_Interactions"                                   
#> [12] "CellPhoneDB_Human_Ligands"                                        
#> [13] "CellPhoneDB_Human_Receptors"                                      
#> [14] "CellTalkDB_Human_Interactions"                                    
#> [15] "CellTalkDB_Mouse_Interactions"                                    
#> [16] "GENCODE_Human_Genes"                                              
#> [17] "GENCODE_Mouse_Genes"                                              
#> [18] "HPA_Human_102Genes_SecretedAndFDAApprovedDrugTargets"             
#> [19] "HPA_Human_12631Genes_NotSecretedOrMembraneBound"                  
#> [20] "HPA_Human_1708Genes_BothSecretedAndMembraneBound"                 
#> [21] "HPA_Human_1708Genes_Secreted"                                     
#> [22] "HPA_Human_19670Genes_GODiseaseDistributionLocation"               
#> [23] "HPA_Human_429Genes_MembraneBoundAndHasFDAApprovedDrugTargets"     
#> [24] "HPA_Human_5520Genes_MembraneBound"                                
#> [25] "HPA_Human_754Genes_FDAApprovedDrugTargets"                        
#> [26] "HPA_Human_ProteinClass_CD"                                        
#> [27] "HPA_Human_ProteinClass_GPCR"                                      
#> [28] "HPA_Human_ProteinClass_Plasma"                                    
#> [29] "HPA_Human_ProteinClass_Transporters"                              
#> [30] "HPA_Human_ProteinClass_VoltageGatedIonChannels"                   
#> [31] "Human_GuideToPHARMACOLOGY_Interactions_LigandTargetsFull"         
#> [32] "Human_GuideToPHARMACOLOGY_Interactions_LigandTargetsFull_Expanded"
#> [33] "Human_GuideToPHARMACOLOGY_Interactions_OnlyTargetsFull_Expanded"  
#> [34] "Human_GuideToPHARMACOLOGY_LigandsPeptides"                        
#> [35] "Human_GuideToPHARMACOLOGY_Targets"                                
#> [36] "Mouse_GuideToPHARMACOLOGY_Interactions_LigandTargetsFull"         
#> [37] "Mouse_GuideToPHARMACOLOGY_Interactions_LigandTargetsFull_Expanded"
#> [38] "Mouse_GuideToPHARMACOLOGY_Interactions_OnlyTargetsFull_Expanded"  
#> [39] "Mouse_GuideToPHARMACOLOGY_LigandsPeptides"                        
#> [40] "Mouse_GuideToPHARMACOLOGY_Targets"                                
#> [41] "TheHumanTranscriptionFactors"                                     
#> [42] "UniProt_ProteinFamily_AllSpecies"                                 
#> [43] "UniProt_ProteinFamily_Human"                                      
#> [44] "UniProt_ProteinFamily_Mouse"                                      
#> [45] "VerSeDa_Mouse_SecretomePrediction"
```
