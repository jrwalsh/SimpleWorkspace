# library(data.table)
# 
# maizegdb.john <- read.delim2("~/Dropbox/v3_v4_assoc/maizegdb.john.txt")
# maizegdb.john <- maizegdb.john[c(1,3,5,6)]
# colnames(maizegdb.john) <- c("V3_gene", "V4_gene", "association_type","quality")
# 
# gramene.old <- read.delim("~/Dropbox/v3_v4_assoc/gramene.old.txt")
# 
# gramene.new <- read.delim("~/Dropbox/v3_v4_assoc/gramene.new.txt")
# gramene.new.blank <- gramene.new[gramene.new$type=="1-to-0",]
# gramene.new <- gramene.new[!(gramene.new$type=="1-to-0"),]
# gramene.new <- gramene.new[,c("V3_gene", "V4_gene")]
# 
# 
# # MaizeGDB intersection Gramene
# maizegdb.gramene <- merge(x=maizegdb.john, y=gramene.new, by=c("V3_gene", "V4_gene"))
# 
# # MaizeGDB but not Gramene
# maizegdb.unique <- setDT(maizegdb.john)[!gramene.new, on=c("V3_gene", "V4_gene")]
# 
# # Gramene but not MaizeGDB
# gramene.unique <- setDT(gramene.new)[!maizegdb.john, on=c("V3_gene", "V4_gene")]
# 
# 
# ## How many of each association type and quality?
# summary(maizegdb.unique$association_type)
# summary(maizegdb.unique$quality)
# ## How many v4 genes shared between the two
# summary(maizegdb.unique$V4_gene %in% gramene.unique$V4_gene)


# Load packages
library(data.table)
library(readxl)

# Import Data
# MaizeGDB_v3_v4.genes <- read.delim("~/Dropbox/v3_v4_assoc/MaizeGDB_v3_v4.genes.txt")
MaizeGDB_v3_v4.genes <- read_excel("B73_v3 to v4 mapping/Data/MaizeGDB_v3_v4.genes.xlsx")
# gramene.new <- read.delim("~/Dropbox/v3_v4_assoc/gramene.new")
gramene.new <- read.delim("~/Dropbox/v3_v4_assoc/gramene.new")
# maizegdb.john <- read.delim2("~/Dropbox/v3_v4_assoc/maizegdb.john.txt")
maizegdb.john <- read.delim2("~/Dropbox/v3_v4_assoc/maizegdb.john.txt")
# gramene.old <- read.delim("~/Dropbox/v3_v4_assoc/gramene.old.txt")
gramene.old <- read.delim("~/Dropbox/v3_v4_assoc/gramene.old.txt")


MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[c(1,2,8,9,20,21)]
colnames(MaizeGDB_v3_v4.genes) <- c("V3_gene", "V3_chr", "V4_gene", "V4_chr", "notes","rejected")
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene=="na"),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene==""),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene=="not in v4"),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(substr(MaizeGDB_v3_v4.genes$V4_gene,1,3)=="zma"),]


  #gramene.new.blank <- gramene.new[gramene.new$type=="1-to-0",]
gramene.new <- gramene.new[!(gramene.new$type=="1-to-0"),]
  #gramene.new <- gramene.new[,c("V3_gene", "V4_gene")]


MaizeGDB_v3_v4.unique <- setDT(MaizeGDB_v3_v4.genes)[!gramene.new, on=c("V3_gene", "V4_gene")]
MaizeGDB_v3_v4.gramene <- merge(x=MaizeGDB_v3_v4.genes, y=gramene.new, by=c("V3_gene", "V4_gene"))
gramene.unique <- setDT(gramene.new)[!MaizeGDB_v3_v4.genes, on=c("V3_gene", "V4_gene")]

write.table(MaizeGDB_v3_v4.unique, "/home/jesse/Dropbox/v3_v4_assoc/MaizeGDB_v3_v4.unique", sep="\t")
write.table(gramene.unique, "/home/jesse/Dropbox/v3_v4_assoc/gramene.unique", sep="\t")



# Overlap of gene content:
length(MaizeGDB_v3_v4.unique$V4_gene)
length(unique(MaizeGDB_v3_v4.unique$V4_gene))
length(unique(MaizeGDB_v3_v4.unique[MaizeGDB_v3_v4.unique$V4_gene %in% gramene.new$V4_gene]$V4_gene))
length(unique(MaizeGDB_v3_v4.unique[!MaizeGDB_v3_v4.unique$V4_gene %in% gramene.new$V4_gene]$V4_gene))

length(gramene.unique$V4_gene)
length(unique(gramene.unique$V4_gene))
length(unique(gramene.unique[gramene.unique$V4_gene %in% MaizeGDB_v3_v4.genes$V4_gene]$V4_gene))
length(unique(gramene.unique[!gramene.unique$V4_gene %in% MaizeGDB_v3_v4.genes$V4_gene]$V4_gene))


# Compare to rejected set
rejected <- read.delim2("~/Dropbox/v3_v4_assoc/Zea_mays.AGPv4.rejected_set.txt", header = FALSE)
rejected <- subset(rejected, V3=="gene", select = c(V1, V2, V3, V9))
rejected <- cbind(rejected, sub("ID=(.*?);.*", "\\1", rejected$V9, perl = TRUE))
colnames(rejected)[5] <- "id"

nrow(gramene.new[gramene.new$V4_gene %in% rejected$id,])
# 2303 genes in the gramene file were from the rejected set, so yes, they did map rejected gene models to v3
nrow(gramene.new[MaizeGDB_v3_v4.genes$V4_gene %in% rejected$id,])
# 2227 and so did MaizeGDB
nrow(gramene.unique[gramene.unique$V4_gene %in% rejected$id,])
# 219 a small percent were in the gramene unique set, which means that maizeGDB and gramene agree on most of the mappings for rejected genes
nrow(MaizeGDB_v3_v4.unique[MaizeGDB_v3_v4.unique$V4_gene %in% rejected$id,])
# 146 a small percent were in the maize unique set, which means that maizeGDB and gramene agree on most of the mappings for rejected genes