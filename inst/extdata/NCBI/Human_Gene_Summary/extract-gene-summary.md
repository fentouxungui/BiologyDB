# 提取 NCBI Summary

## 基于gbff文件 （不推荐，仅6846基因）

下载路径： https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/RefSeqGene/ 里的gbff.gz文件

其他物种的类似！

下载：

```bash
for i in $(seq 1 7)
do
# wget https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/RefSeqGene/refseqgene.${i}.genomic.gbff.gz 
echo https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/RefSeqGene/refseqgene.${i}.genomic.gbff.gz 
done
# 使用Neat Download Manager软件下载
```

整理：

```python
import os
def Merge(dict1, dict2):
    res = {**dict1, **dict2}
    return res
def extract_summary(file):
    f = open(file)
    locus2comment = {}
    in_comment = False
    for line in f:
        if line[0:5] == "LOCUS":
            locus = line.split()[1]
            comment = ""
        elif line[0:7] == "COMMENT":
            in_comment = True
            comment += line.split("    ")[1].replace("\n", " ")
        elif line[0:7] == "PRIMARY":
            in_comment = False
            try:
                locus2comment[locus] = comment.split("Summary:")[1]
            except:
                locus2comment[locus] = comment
        elif in_comment:
            comment += line.split("            ")[1].replace("\n", " ")
    return locus2comment

dirpath = 'C:\\Users\Xi_Lab\Desktop\\NCBI-extract-Summary\\DownloadedData'

res = {}
for f in os.listdir(dirpath):
    if os.path.splitext(f)[-1] == ".gbff":
        print("Processing: " + f + "...")
        res = Merge(res, extract_summary(file=dirpath + "\\" + f))

for locus in sorted(res):
    with open('C:\\Users\Xi_Lab\Desktop\\NCBI-extract-Summary\\NCBI_gene_summary.txt', 'a') as f:
        f.write(locus + '\t' + res[locus] + '\n')
    # print(locus + '\t' + res[locus])
```

仅仅6846条记录！

## 基于ASN文件

下载地址： https://ftp.ncbi.nlm.nih.gov/gene/DATA/ASN_BINARY/Mammalia/Homo_sapiens.ags.gz

ubuntu系统中

```
apt-get install ncbi-tools-bin
gene2xml -i ./Homo_sapiens.ags.gz -o ./Homo_sapiens.xml -c T -l T -b T
```

### Python + Linux

参考：https://biopython.org/docs/dev/api/index.html

```python
# ref: https://blog.51cto.com/u_14782715/5082276
from Bio import Entrez
# =====解析大文件=====
# hd_parse = open("C:\\Users\Xi_Lab\\Desktop\\NCBI-extract-Summary\\Homo_sapiens.xml", "rb")
hd_parse = open("C:\\Users\Xi_Lab\\Desktop\\NCBI-extract-Summary\\subset.xml", "rb")
res_parse = Entrez.parse(hd_parse)
for record in res_parse:
    status = record['Entrezgene_track-info']['Gene-track']['Gene-track_status']
    if status.attributes['value'] == 'discontinued':
        continue
    gene_id = record['Entrezgene_track-info']['Gene-track']['Gene-track_geneid']
    # 有一些ID没有Gene-ref_locus
    if 'Gene-ref_locus' not in record['Entrezgene_gene']['Gene-ref'].keys():
        continue
    else:
        gene_name = record['Entrezgene_gene']['Gene-ref']['Gene-ref_locus']
    # 有的没有Entrez gene_summary
    if 'Entrezgene_summary' in record.keys():
        gene_summary = record['Entrezgene_summary']
    else:
        gene_summary = ""
    with open('C:\\Users\Xi_Lab\Desktop\\NCBI-extract-Summary\\NCBI_gene_summary_2.txt', 'a') as f:
        f.write(gene_id + '\t' + gene_name + '\t' + gene_summary + '\n')
    # print(gene_id, gene_name, gene_summary)


```

```bash
# 跑到一个地方报错了，可以提取剩余的
# 获取截取位置
cat Homo_sapiens.xml | grep "<Entrezgene>\|<Gene-ref_locus>" -n | grep "LRRC56" -B10 -A10
cat Homo_sapiens.xml | sed '4,425058435d' > subset.xml
```



### Linux + R (推荐)

相对更快，结果也做了xml符号替换！

```bash
cat Homo_sapiens.xml | grep "<Gene-track_geneid>\|<Gene-ref_locus>\|<Entrezgene_summary>" > subset.txt
```

```R
# 太慢了
# con <- file("./subset.txt", "r")
# line=readLines(con,n=1)
# content <- c()
# while( length(line) != 0 ) {
#   content <- append(content,gsub("^\\s+","",line))
#   line=readLines(con,n=1)
# }
# close(con)

df <- read.delim("./subset.txt",stringsAsFactors = FALSE)
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

write.table(results,file = "NCBI_gene_summary_from_ASN.txt",row.names = FALSE,quote = FALSE,sep = "\t")

results <- results[results$summary != "",]
write.table(results,file = "NCBI_gene_summary_from_ASN_filtered.txt",row.names = FALSE,quote = FALSE,sep = "\t")
```



# 数据整理

```R
# 如果仔细对应基因，比较麻烦，这里只简单地对数据进行过滤！基因名是否过时不再考虑！
ncbi <- read.delim("./NCBI/NCBI_gene_summary_from_ASN.txt",stringsAsFactors = FALSE,quote = "")
ncbi <- ncbi[!grepl("^DISCONTINUED",ncbi$summary),]
ncbi <- ncbi[ncbi$summary != "",]
ncbi <- ncbi[ncbi$Symbol != "",]

library(dplyr)
# 去重重复的基因名，仅保留gene_id值最大的，简单看了几个，id值小的貌似已经被NCBI删除了
ncbi %>%
  group_by(Symbol) %>%
  top_n(1,gene_id) -> ncbi.2

saveRDS(ncbi.2,file = "ncbi_summay.rds")



# 处理完成后，ncbi是没有重复的symbol的，而uniprot有重复的symbol，展示时合到一起，并且显示Entry条目！
```















