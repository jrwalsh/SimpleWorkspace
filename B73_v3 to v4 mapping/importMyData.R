  ## Load packages
library(data.table)
library(readxl)

  ## Import Data
MaizeGDB_v3_v4.genes <- read_excel("B73_v3 to v4 mapping/Data/MaizeGDB_v3_v4.genes.xlsx", )
gramene.new <- read.delim("B73_v3 to v4 mapping/Data/gramene.new")
maizegdb.john <- read.delim2("B73_v3 to v4 mapping/Data/maizegdb.john")
gramene.old <- read.delim("B73_v3 to v4 mapping/Data/gramene.old")
rejected <- read.delim2("~/Dropbox/v3_v4_assoc/Zea_mays.AGPv4.rejected_set.txt", header = FALSE)

  ## Clean Data
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[c(1,2,8,9,20,21)]
colnames(MaizeGDB_v3_v4.genes) <- c("V3_gene", "V3_chr", "V4_gene", "V4_chr", "notes","rejected")
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene=="na"),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene==""),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene=="not in v4"),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(substr(MaizeGDB_v3_v4.genes$V4_gene,1,3)=="zma"),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!is.na(MaizeGDB_v3_v4.genes$V3_gene),]

gramene.new <- gramene.new[!(gramene.new$type=="1-to-0"),]
gramene.new <- gramene.new[,c("V3_gene", "V4_gene")]

rejected <- subset(rejected, V3=="gene", select = c(V1, V2, V3, V9))
rejected <- cbind(rejected, sub("ID=(.*?);.*", "\\1", rejected$V9, perl = TRUE))
colnames(rejected)[5] <- "id"

  ## Generate useful subsets
MaizeGDB_v3_v4.unique <- setDT(MaizeGDB_v3_v4.genes)[!gramene.new, on=c("V3_gene", "V4_gene")]
MaizeGDB_v3_v4.gramene <- merge(x=MaizeGDB_v3_v4.genes, y=gramene.new, by=c("V3_gene", "V4_gene"))
gramene.unique <- setDT(gramene.new)[!MaizeGDB_v3_v4.genes, on=c("V3_gene", "V4_gene")]