# Process_Ulda.R
# Process the data received from Ulda

library(readxl)
library(taxotools)
master_ioc_list_v10_1_updated <- read_excel("input/master_ioc_list_v10.1 updated.xlsx",
                                            range = "A9:DK38976")

Lice_Ulda <- master_ioc_list_v10_1_updated[,36:62]
Lice_Ulda <- Lice_Ulda[!is.na(Lice_Ulda$genus3),]

Lice_Ulda <- melt_canonical(Lice_Ulda,
                            canonical = "(sub)species",
                            genus = "genus",
                            species = "Species",
                            subspecies = "subspecies"
)
Lice_Ulda <- cast_canonical(Lice_Ulda,
                            canonical = "canonical",
                            genus = "genus",
                            species = "Species",
                            subspecies = "subspecies")

testmatch1 <- match_lists(LiceV1_m,Lice_Ulda,"canonical","canonical")

