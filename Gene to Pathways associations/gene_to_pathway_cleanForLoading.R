####################################################################################################
## Mini-Project: List Gene to Pathways associations for loading into MaizeGDB
## Script purpose: Take the messy output from CornCyc and clean it up into a gene->pathway lookup table.
##
## Mini-Project collaborating with: Ethy Cannon
## Jira Issue: WEB-5
##
## Input: Data from CornCyc 8 (http://corncyc_b73_v4.maizegdb.org/) using 
##      query 
##        html-sort-ascending([(Z1^?FRAME-ID, Z1^?NAME, Z1^?GENES-OF-PATHWAY) :  Z1<-CORN^^Pathways],1)
##
## Date: 2017-08-08
## Author: Jesse R. Walsh
####################################################################################################
library(readr)
library(tidyr)
library(dplyr)

pathway_genes.raw <- 
  read_delim("~/git/SimpleWorkspace/Gene to Pathways associations/query-results.tsv", 
             "\t", 
             escape_double = FALSE, 
             col_names = c("PathwayID", "PathwayName", "GeneList"), 
             trim_ws = TRUE)

pathway_genes <- 
  pathway_genes.raw %>%
  subset(!is.na(GeneList)) %>%
  mutate(GeneList = gsub("\"", "", GeneList)) %>%
  mutate(GeneList = gsub("\\(", "", .$GeneList)) %>%
  mutate(GeneList = gsub("\\)", "", .$GeneList)) %>%
  mutate(GeneList = strsplit(as.character(GeneList) , " ")) %>%
  unnest(GeneList)

write.table(pathway_genes, "~/git/SimpleWorkspace/Gene to Pathways associations/Pathway_Genes.tsv", sep="\t", row.names=FALSE)
