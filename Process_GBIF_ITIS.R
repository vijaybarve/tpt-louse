# Process_GBIF_ITIS.R
# Process Louse data downloaded from GBIF and ITIS

library(taxotools)
library(readr)
GBIF_Psocodea <- read_delim("input/GBIF_Psocodea.csv",
                            "\t", escape_double = FALSE, trim_ws = TRUE)

Lice_GBIF <- DwC2taxo(GBIF_Psocodea,source = "GBIF")
#Lice_GBIF_n <- DwC2taxoYS(GBIF_Psocodea,source = "GBIF")

Lice_GBIF <- Lice_GBIF[which(Lice_GBIF$family %in% unique(LiceV1_m$family)),]

Lice_GBIF_res1 <- get_accepted_names(Lice_GBIF,
                                     LiceV1_m,
                                     gen_syn = Lice_gen_syn,
                                     canonical = "canonical")
Lice_GBIF_res <- get_accepted_names(Lice_GBIF,
                                    LiceV1_m,
                                    canonical = "canonical")
rm(GBIF_Psocodea)

GBIF_Psocodea_bb <- read_delim("input/psocodea_gbif_complete_20210324.tsv",
                               "\t", escape_double = FALSE, trim_ws = TRUE)
Lice_GBIF_bb <- DwC2taxo(GBIF_Psocodea_bb,source = "GBIF")
Lice_GBIF_bb <- Lice_GBIF_bb[which(Lice_GBIF_bb$family %in% unique(LiceV1_m$family)),]


# Lice ITIS
ITIS_Psocodea <- read_delim("input/ITIS_Psocodea.txt",
                            "\t", escape_double = FALSE, trim_ws = TRUE)

Lice_ITIS <- DwC2taxo(ITIS_Psocodea, source = "ITIS")
Lice_ITIS <- Lice_ITIS[which(Lice_ITIS$family %in% unique(LiceV1_m$family)),]

Lice_ITIT_res <- get_accepted_names(Lice_ITIS,
                                    LiceV1_m,
                                    canonical = "canonical")
rm(ITIS_Psocodea)

