# Merge_Louse.R
# Merging the LouseV1, NHM, Ulda and GBIF data to get a master file of names
# With taxotools V0.0.111 or later

library(plyr)
library(taxotools)
Louse_m1 <- merge_lists(LiceV1_m,Lice_GBIF_bb,"merged")
Louse_m2 <- merge_lists(Louse_m1,Ulda_t,"merged")
Louse_m3 <- merge_lists(Louse_m2,lice_nhm,"merged")