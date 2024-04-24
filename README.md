
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BiologyDB

<!-- badges: start -->
<!-- badges: end -->

> 为什么做这件事？
> 初衷是用于做基因的注释，后来发现有些数据库多多少少有些问题，比如基因名错了、基因ID过时了等等，为了方便重复使用数据库，所以将常用的数据库整理好了，方便重复调用。数据库预处理的原则是简单又灵活。

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
#>  [1] "AnimalTFDB_Fly_TF"                                                
#>  [2] "AnimalTFDB_Fly_TFCofactors"                                       
#>  [3] "AnimalTFDB_Human_TF"                                              
#>  [4] "AnimalTFDB_Human_TFCofactors"                                     
#>  [5] "AnimalTFDB_Mouse_TF"                                              
#>  [6] "AnimalTFDB_Mouse_TFCofactors"                                     
#>  [7] "CellChat_Human_LigandReceptorsInteractions"                       
#>  [8] "CellChat_Human_Ligands"                                           
#>  [9] "CellChat_Human_Receptors"                                         
#> [10] "CellChat_Mouse_LigandReceptorsInteractions"                       
#> [11] "CellChat_Mouse_Ligands"                                           
#> [12] "CellChat_Mouse_Receptors"                                         
#> [13] "CellPhoneDB_Human_Interactions"                                   
#> [14] "CellPhoneDB_Human_Ligands"                                        
#> [15] "CellPhoneDB_Human_Receptors"                                      
#> [16] "CellTalkDB_Human_Interactions"                                    
#> [17] "CellTalkDB_Mouse_Interactions"                                    
#> [18] "Flybase_Fly_AutomatedGeneSummary"                                 
#> [19] "Flybase_Fly_BestGeneSummary"                                      
#> [20] "Flybase_Fly_GeneSnapshots"                                        
#> [21] "Flybase_Fly_Genes"                                                
#> [22] "GENCODE_Human_Genes"                                              
#> [23] "GENCODE_Mouse_Genes"                                              
#> [24] "HPA_Human_102Genes_SecretedAndFDAApprovedDrugTargets"             
#> [25] "HPA_Human_12631Genes_NotSecretedOrMembraneBound"                  
#> [26] "HPA_Human_1708Genes_BothSecretedAndMembraneBound"                 
#> [27] "HPA_Human_1708Genes_Secreted"                                     
#> [28] "HPA_Human_19670Genes_GODiseaseDistributionLocation"               
#> [29] "HPA_Human_429Genes_MembraneBoundAndHasFDAApprovedDrugTargets"     
#> [30] "HPA_Human_5520Genes_MembraneBound"                                
#> [31] "HPA_Human_754Genes_FDAApprovedDrugTargets"                        
#> [32] "HPA_Human_ProteinClass_CD"                                        
#> [33] "HPA_Human_ProteinClass_GPCR"                                      
#> [34] "HPA_Human_ProteinClass_Plasma"                                    
#> [35] "HPA_Human_ProteinClass_Transporters"                              
#> [36] "HPA_Human_ProteinClass_VoltageGatedIonChannels"                   
#> [37] "Human_GuideToPHARMACOLOGY_Interactions_LigandTargetsFull"         
#> [38] "Human_GuideToPHARMACOLOGY_Interactions_LigandTargetsFull_Expanded"
#> [39] "Human_GuideToPHARMACOLOGY_Interactions_OnlyTargetsFull_Expanded"  
#> [40] "Human_GuideToPHARMACOLOGY_LigandsPeptides"                        
#> [41] "Human_GuideToPHARMACOLOGY_Targets"                                
#> [42] "Mouse_GuideToPHARMACOLOGY_Interactions_LigandTargetsFull"         
#> [43] "Mouse_GuideToPHARMACOLOGY_Interactions_LigandTargetsFull_Expanded"
#> [44] "Mouse_GuideToPHARMACOLOGY_Interactions_OnlyTargetsFull_Expanded"  
#> [45] "Mouse_GuideToPHARMACOLOGY_LigandsPeptides"                        
#> [46] "Mouse_GuideToPHARMACOLOGY_Targets"                                
#> [47] "NCBI_Human_GeneSummary"                                           
#> [48] "NCBI_Mouse_GeneSummary"                                           
#> [49] "TheHumanTranscriptionFactors"                                     
#> [50] "UniProt_Human_GeneFunction"                                       
#> [51] "UniProt_Mouse_GeneFunction"                                       
#> [52] "UniProt_ProteinFamily_AllSpecies"                                 
#> [53] "UniProt_ProteinFamily_Human"                                      
#> [54] "UniProt_ProteinFamily_Mouse"                                      
#> [55] "VerSeDa_Mouse_SecretomePrediction"
```
