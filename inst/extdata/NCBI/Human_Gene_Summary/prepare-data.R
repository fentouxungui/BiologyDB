# summ <- read.delim("./NCBI_gene_summary.txt",col.names = c("id","summary"),stringsAsFactors = FALSE)
# mapid <- read.delim("./LRG_RefSeqGene",stringsAsFactors = FALSE)
# head(mapid)
# gene.all <- gsub("\\.\\d+","",unique(mapid$RSG))
# gene.exist <- unique(summ$id)
# gene.all[!gene.all %in% gene.exist]
# mapid[gsub("\\.\\d+","",mapid$RSG) == "NG_000006",]


# 太慢了
# con <- file("./subset.txt", "r")
# line=readLines(con,n=1)
# content <- c()
# while( length(line) != 0 ) {
#   content <- append(content,gsub("^\\s+","",line))
#   line=readLines(con,n=1)
# }
# close(con)

df <- read.delim("./subset.txt",stringsAsFactors = FALSE,col.names = "con")
con <- gsub("^\\s+","",df$con)
A <- which(grepl("^<Gene-track_geneid>",con))
B <- which(grepl("^<Gene-ref_locus>",con))
C <- which(grepl("^<Entrezgene_summary>",con))
all((B-1) %in% A) # B肯定在对应的A的后面？是的！
all((C-1) %in% B) # C肯定在B的后面? 不是的！
all((C-2) %in% A) # C肯定在A的后面? 不是的！
# those entry without B(gene symbol)
con[C[which(!(C-2) %in% A)]]
con[C[which(!(C-2) %in% A)] - 1]
AC <- c(C[(C-2) %in% A] - 2,C[!((C-2) %in% A)] - 1)

results <- data.frame(row.names = 1:length(A),
                      gene_id = gsub("</Gene-track_geneid>","",gsub("<Gene-track_geneid>","",con[A],fixed = TRUE),fixed = TRUE),
                      Symbol = rep("",length(A)),
                      summary = rep("",length(A)))
results$Symbol[which(A %in% (B-1))] <- gsub("</Gene-ref_locus>","",gsub("<Gene-ref_locus>","",con[B],fixed = TRUE),fixed = TRUE)
results$summary[which(A %in% AC)] <- gsub("</Entrezgene_summary>","",gsub("<Entrezgene_summary>","",con[C],fixed = TRUE),fixed = TRUE)
head(results)


# xml中的特殊符号
# ref: https://blog.csdn.net/u010620152/article/details/55258114
results$summary[grepl("&lt;",results$summary,fixed = TRUE)]
results$summary[grepl("&gt;",results$summary,fixed = TRUE)]
results$summary[grepl("&amp;",results$summary,fixed = TRUE)]
results$summary[grepl("&apos;",results$summary,fixed = TRUE)]
results$summary[grepl("&quot;",results$summary,fixed = TRUE)]

results$summary <- gsub("&lt;","<",results$summary,fixed = TRUE)
results$summary <- gsub("&gt;",">",results$summary,fixed = TRUE)
results$summary <- gsub("&amp;","&",results$summary,fixed = TRUE)
results$summary <- gsub("&apos;","'",results$summary,fixed = TRUE)
results$summary <- gsub("&quot;",'"',results$summary,fixed = TRUE)

results$summary[grepl("&",results$summary,fixed = TRUE)]
results[grepl("&",results$summary,fixed = TRUE),]

results$summary <- gsub("&#945;","β",results$summary,fixed = TRUE)
results$summary <- gsub("&#8242;",'″',results$summary,fixed = TRUE)
results$summary <- gsub("&#8208;",'-',results$summary,fixed = TRUE) # &#8208; 找不到，猜测是-
results$summary <- gsub("&#954;",'κ',results$summary,fixed = TRUE)
results$summary <- gsub("&#8594;",'→',results$summary,fixed = TRUE)

# write.table(results,file = "NCBI_gene_summary_from_ASN.txt",row.names = FALSE,quote = FALSE,sep = "\t")
results <- results[results$summary != "",]
dim(results)
results <- results[!grepl("DISCONTINUED", results$summary),]
dim(results)
saveRDS(results,file ="NCBI_gene_summary_from_ASN_filtered.rds" )
# write.table(results,file = "NCBI_gene_summary_from_ASN_filtered.txt",row.names = FALSE,quote = FALSE,sep = "\t")

# download: https://www.ncbi.nlm.nih.gov/sites/books/NBK3840/
# https://ftp.ncbi.nih.gov/gene/DATA/GENE_INFO/Mammalia/Homo_sapiens.gene_info.gz
df <- read.delim("./Homo_sapiens.gene_info.gz",stringsAsFactors = FALSE)
table(duplicated(df$GeneID))
table(df$GeneID %in% results$gene_id)
table(results$gene_id %in% df$GeneID)
df$Ensembl <- unlist(lapply(strsplit(df$dbXrefs, split = "\\|"),function(x){
  return(paste0(gsub("Ensembl:", "", x[grepl("^Ensembl", x)]),collapse = ";"))
}))
df$HGNC <- unlist(lapply(strsplit(df$dbXrefs, split = "\\|"),function(x){
  return(paste0(gsub("^HGNC:", "", x[grepl("^HGNC:", x)]),collapse = ";"))
}))

results$Ensembl <- df$Ensembl[match(results$gene_id, df$GeneID)]
results$HGNC <- df$HGNC[match(results$gene_id, df$GeneID)]

library(AnnotationDbi)
library(org.Hs.eg.db)
library(BiologyDB)
results$Ensembl.By.OrgHSegdb <- mapIds(x = org.Hs.eg.db, keys = results$gene_id,column = "ENSEMBL",keytype = "ENTREZID",multiVals = "first")
colnames(results)[1] <- "EntrezID"
saveRDS(results, file = "./NCBI_gene_summary_from_ASN_filtered.rds")
