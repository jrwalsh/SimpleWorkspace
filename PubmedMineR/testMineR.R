library(pubmed.mineR)
##################################################################################################
# Purpose:
#
# Input:
#
# Output:
#
# Usage:
#
# @author Jesse Walsh - 5/5/2017
##################################################################################################

# pubmed abstracts from https://www.ncbi.nlm.nih.gov/pubmed/?term=maize+protein
abstracts <- readabs("PubmedMineR/Data/pubmed_result_maize_protein.txt")
pubtator_output <- pubtator_function(abstracts@PMID[1])

