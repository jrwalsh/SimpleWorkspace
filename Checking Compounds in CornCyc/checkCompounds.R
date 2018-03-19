library(readr)
library(tidyr)
library(dplyr)
####################################################################################################
## Project: 
## Script purpose: 
##
## Input: 
## Output: 
## Date: 2017-08-28
## Author: Jesse R. Walsh
##
## Data built using JavaCycO query:
# public static void checkCompounds() {
#   int port = 4444;
#   String organism = "CORN";
#   JavacycConnection conn = new JavacycConnection("localhost", port);
#   conn.selectOrganism(organism);
#   try {
#     String out = "";
#     for (Frame compound : conn.getAllGFPInstances(Compound.GFPtype)) {
#       out += compound.getLocalID() + "\t" + compound.getCommonName() + "\t" + compound.getSlotValue("SMILES") + "\t" + compound.getSlotValue("InChI") + "\t" + compound.isClassFrame() + "\n";
#     }
#     printString(new File("compounds.tab"), out);
#   } catch (PtoolsErrorException e) {
#     // TODO Auto-generated catch block
#     e.printStackTrace();
#   }
# }
####################################################################################################
compounds <- read_delim("~/git/SimpleWorkspace/Checking Compounds in CornCyc/Data/compounds.tab", 
                        "\t", escape_double = FALSE, col_types = cols(`CLASS?` = col_logical()), 
                        na = "null", trim_ws = TRUE)

## Frequency of NA in SMILES and INCHI
compounds %>% subset(is.na(SMILES)) %>% nrow()
compounds %>% subset(is.na(INCHI)) %>% nrow()

## Duplicated SMILES
compounds[duplicated(compounds$SMILES) | duplicated(compounds$SMILES, fromLast = TRUE),] %>% subset(!is.na(SMILES)) %>% nrow()

## Duplicated InChI
compounds[duplicated(compounds$INCHI) | duplicated(compounds$INCHI, fromLast = TRUE),] %>% subset(!is.na(INCHI)) %>% nrow()