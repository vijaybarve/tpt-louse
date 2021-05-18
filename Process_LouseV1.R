# Process_LouseV1.R
# Process Lice Master V1 to taxolist

library(taxotools)
library(readr)
LiceV1 <- read_csv("input/Phthiraptera.taxonomy.V1.csv")

LiceV1$id <- seq(1:nrow(LiceV1))
LiceV1$accid <- 0

# Move subgenus to its own field form species_1 
for(i in 1:nrow(LiceV1)){
  spn <- LiceV1$species_1[i]
  if(grepl( "(",LiceV1$species_1[i], fixed = TRUE)){
    LiceV1$subgenus[i] <- gsub("[\\(\\)]", "", 
                               regmatches(spn, gregexpr("\\(.*?\\)", spn))[[1]])
    LiceV1$species_1[i] <- gsub("\\s*\\([^\\)]+\\)","",as.character(spn))
    
  }
}

LiceV1 <- melt_canonical(LiceV1,"species_1","Genus_1","species","subspecies")

# Work on synonyms now
LiceV1_syn <- melt_cs_field(LiceV1,"synonyms",sepchar = ";")
LiceV1_syn <- LiceV1_syn[which(!is.na(LiceV1_syn$synonyms)),]

LiceV1_syn <- melt_scientificname(LiceV1_syn,
                                  sciname = "synonyms",
                                  genus = "syn_genus",
                                  subgenus = "syn_subgenus",
                                  species = "syn_species",
                                  subspecies = "syn_subspecies",
                                  author = "syn_author",
)

LiceV1_syn$accid <- LiceV1_syn$id
LiceV1_syn$id <- seq(nrow(LiceV1)+1,nrow(LiceV1)+nrow(LiceV1_syn))

LiceV1_a <- LiceV1[,c("id","accid","order", "suborder", "infraorder", 
                      "parvorder", "nanorder", "superfamily", "family",
                      "Genus_1","subgenus","species","subspecies","author")]
names(LiceV1_a) <- c("id","accid","order", "suborder", "infraorder", 
                     "parvorder", "nanorder", "superfamily", "family",
                     "genus","subgenus","species","subspecies","author")
LiceV1_s <- LiceV1_syn[,c("id","accid","order", "suborder", "infraorder", 
                          "parvorder", "nanorder", "superfamily", "family",
                          "syn_genus","syn_subgenus","syn_species","syn_subspecies",
                          "syn_author")]
names(LiceV1_s) <- c("id","accid","order", "suborder", "infraorder", 
                     "parvorder", "nanorder", "superfamily", "family",
                     "genus","subgenus","species","subspecies","author")

LiceV1_m <- rbind(LiceV1_a,LiceV1_s)
LiceV1_m <- cast_canonical(LiceV1_m,
                           canonical = "canonical",
                           genus = "genus",
                           species = "species",
                           subspecies = "subspecies")

LiceV1_m$source <- "TPT_v1"
write.csv(LiceV1_m,"output\\LiceV1_taxo.csv",row.names = F)
rm(list=c("i", "LiceV1", "LiceV1_a", "LiceV1_s", "LiceV1_syn", "spn"))


