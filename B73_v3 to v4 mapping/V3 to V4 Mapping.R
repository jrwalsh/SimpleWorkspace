##################################################################################################
# Purpose:
# This script is ment to answer some questions about what makes the v3->v4 mapping file that gramene
# created different from the one we (maggie+ethy) created.  I don't know the difference in their
# pipelines yet, but both used the same basic pipeline and treated the outliers differently. I
# would like to compare and contrast these files.
#
# Input:
# MaizeGDB_v3_v4.genes.xlsx - MaizeGDB mapping file available at
# http://ftp.maizegdb.org/MaizeGDB/FTP/GeneModels_Zm00001d/MaizeGDB_v3_v4.genes.xlsx
# gramene.new - gramene mapping file available at 
# ftp://ftp.gramene.org/pub/gramene/CURRENT_RELEASE/data/gff3/zea_mays/gene_id_mapping_v3_to_v4/maize.v3TOv4.geneIDhistory.txt
# gramene.old.txt - old file sent to us by gramene (from John)
# maizegdb.john.txt - db dump given to me by John
# Zea_mays.AGPv4.rejected_set.txt - given to me by Maggie, these are the genes in the v4 rejected set
#
# Output:
# N/A
#
# Usage:
# Exploratory. Run various comparison to calculate matches, non-matches, etc.
#
# @author Jesse Walsh - 4/17/2017
##################################################################################################
  ## Initialize Environment
source("./B73_v3 to v4 mapping/importMyData.R")

  ## Print basic statistics:
print(paste0(nrow(MaizeGDB_v3_v4.gramene),
             " MaizeGDB mappings which are the same as mappings in gramene"))

print(paste0(length(MaizeGDB_v3_v4.unique$V4_gene), " v4 mappings in the MaizeGDB set"))
print(paste0(length(unique(MaizeGDB_v3_v4.unique$V4_gene)), " v4 genes (non duplicated) in the MaizeGDB set"))
print(paste0(length(unique(MaizeGDB_v3_v4.unique[MaizeGDB_v3_v4.unique$V4_gene %in% gramene.new$V4_gene, ]$V4_gene)),
             " v4 genes in the unique MaizeGDB mappings which have a different mapping in gramene"))
print(paste0(length(unique(MaizeGDB_v3_v4.unique[!MaizeGDB_v3_v4.unique$V4_gene %in% gramene.new$V4_gene, ]$V4_gene)),
             " v4 genes in the unique MaizeGDB mappings which are not in gramene at all"))

print(paste0(length(gramene.unique$V4_gene), " v4 mappings in the gramene set"))
print(paste0(length(unique(gramene.unique$V4_gene)), " v4 genes (non duplicated) in the gramene set"))
print(paste0(length(unique(gramene.unique[gramene.unique$V4_gene %in% MaizeGDB_v3_v4.genes$V4_gene]$V4_gene)), 
             " v4 genes in the unique gramene mappings which have a different mapping in MaizeGDB"))
print(paste0(length(unique(gramene.unique[!gramene.unique$V4_gene %in% MaizeGDB_v3_v4.genes$V4_gene]$V4_gene)), 
             " v4 genes in the unique gramene mappings which are not in MaizeGDB at all"))


# Got some funky type errors here, so need to coerce to data frame even though they are already data frames
MaizeGDB_v3_v4.genes <- as.data.frame(MaizeGDB_v3_v4.genes)
MaizeGDB_v3_v4.unique <- as.data.frame(MaizeGDB_v3_v4.unique)
rejected <- as.data.frame(rejected)
print(paste0(nrow(gramene.new[gramene.new$V4_gene %in% rejected$gene_id,]), 
            " genes in the gramene file were from the rejected set, so yes, they did map rejected gene models to v3"))
print(paste0(nrow(MaizeGDB_v3_v4.genes[MaizeGDB_v3_v4.genes$V4_gene %in% rejected$gene_id,]), "... and so did MaizeGDB"))
print(paste0(nrow(gramene.unique[gramene.unique$V4_gene %in% rejected$gene_id,]), 
             " a small percent were in the gramene unique set, which means that maizeGDB and gramene agree on most", 
             " of the mappings for rejected genes"))
print(paste0(nrow(MaizeGDB_v3_v4.unique[MaizeGDB_v3_v4.unique$V4_gene %in% rejected$gene_id,]), 
             " a small percent were in the maize unique set, which means that maizeGDB and gramene agree on most of ",
             " the mappings for rejected genes"))

# Output
# write.table(MaizeGDB_v3_v4.unique, "/home/jesse/Dropbox/v3_v4_assoc/MaizeGDB_v3_v4.unique", sep="\t")
# write.table(gramene.unique, "/home/jesse/Dropbox/v3_v4_assoc/gramene.unique", sep="\t")
