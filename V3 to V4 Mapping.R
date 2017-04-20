library(data.table)

maizegdb.john <- read.delim2("~/Dropbox/v3_v4_assoc/maizegdb.john.txt")
maizegdb.john <- maizegdb.john[c(1,3,5,6)]
colnames(maizegdb.john) <- c("V3_gene", "V4_gene", "association_type","quality")

gramene.old <- read.delim("~/Dropbox/v3_v4_assoc/gramene.old.txt")

gramene.new <- read.delim("~/Dropbox/v3_v4_assoc/gramene.new.txt")
gramene.new.blank <- gramene.new[gramene.new$type=="1-to-0",]
gramene.new <- gramene.new[!(gramene.new$type=="1-to-0"),]
gramene.new <- gramene.new[,c("V3_gene", "V4_gene")]


# MaizeGDB intersection Gramene
maizegdb.gramene <- merge(x=maizegdb.john, y=gramene.new, by=c("V3_gene", "V4_gene"))

# MaizeGDB but not Gramene
maizegdb.unique <- setDT(maizegdb.john)[!gramene.new, on=c("V3_gene", "V4_gene")]

# Gramene but not MaizeGDB
gramene.unique <- setDT(gramene.new)[!maizegdb.john, on=c("V3_gene", "V4_gene")]


## How many of each association type and quality?
summary(maizegdb.unique$association_type)
summary(maizegdb.unique$quality)
## How many v4 genes shared between the two
summary(maizegdb.unique$V4_gene %in% gramene.unique$V4_gene)



# Again...
library(data.table)

MaizeGDB_v3_v4.genes <- read.delim("~/Dropbox/v3_v4_assoc/MaizeGDB_v3_v4.genes.txt")
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[c(1,2,8,9,20,21)]
colnames(MaizeGDB_v3_v4.genes) <- c("V3_gene", "V3_chr", "V4_gene", "V4_chr", "notes","rejected")
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene=="na"),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene==""),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(MaizeGDB_v3_v4.genes$V4_gene=="not in v4"),]
MaizeGDB_v3_v4.genes <- MaizeGDB_v3_v4.genes[!(substr(MaizeGDB_v3_v4.genes$V4_gene,1,3)=="zma"),]

gramene.new <- read.delim("~/Dropbox/v3_v4_assoc/gramene.new")
  #gramene.new.blank <- gramene.new[gramene.new$type=="1-to-0",]
gramene.new <- gramene.new[!(gramene.new$type=="1-to-0"),]
  #gramene.new <- gramene.new[,c("V3_gene", "V4_gene")]


MaizeGDB_v3_v4.unique <- setDT(MaizeGDB_v3_v4.genes)[!gramene.new, on=c("V3_gene", "V4_gene")]
MaizeGDB_v3_v4.gramene <- merge(x=MaizeGDB_v3_v4.genes, y=gramene.new, by=c("V3_gene", "V4_gene"))
gramene.unique <- setDT(gramene.new)[!MaizeGDB_v3_v4.genes, on=c("V3_gene", "V4_gene")]

write.table(MaizeGDB_v3_v4.unique, "/home/jesse/Dropbox/v3_v4_assoc/MaizeGDB_v3_v4.unique", sep="\t")
write.table(gramene.unique, "/home/jesse/Dropbox/v3_v4_assoc/gramene.unique", sep="\t")


