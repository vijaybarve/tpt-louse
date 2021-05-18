# Process_NHM.R
# Process NMH lice data to taxolist

library(taxotools)
library(readr)
lice <- read_csv("input//lice.csv")

lice_s <- melt_canonical(lice,
                         canonical = "Name",
                         genus = "genus",
                         species = "species",
                         subspecies = "subspecies"
)
# The file contains all taxonomic levels so separate Species and 
# subspecific entities

lice_sp <- lice[which(lice_s$Rank_1 %in% c("Species","Subspecies","Variety")),
                c("Name","Authority","Rank_1","Associated accepted name",
                  "Synonym Of", "Reference","Usage","URL","Term ID",
                  "Original ID", "Original Parent ID" )]


lice_ac <- lice_sp[which(is.na(lice_sp$`Associated accepted name`)),]
lice_ac$id <- seq(1:nrow(lice_ac))
lice_ac$accid <- 0

lice_syn <- lice_sp[which(!is.na(lice_sp$`Associated accepted name`)),]
lice_syn$id <- seq((nrow(lice_ac)+1),(nrow(lice_ac)+nrow(lice_syn)))
lice_syn$accid <- lice_ac$id[match(lice_syn$`Associated accepted name`,
                                   lice_ac$Name)]

lice_nhm <- rbind(lice_ac,lice_syn)
lice_nhm <- melt_canonical (lice_nhm,
                            canonical = "Name",
                            genus = "genus",
                            species = "species",
                            subspecies = "subspecies")

lice_nhm <- cast_canonical (lice_nhm,
                            canonical = "canonical",
                            genus = "genus",
                            species = "species",
                            subspecies = "subspecies")

#lice_gen <- lice_s[!duplicated(lice_s$genus),]
lice_gen <- lice_s[which(lice$Rank_1=="Genus"),]
lice_gen$family <- lice_s$Name[match(lice_gen$`Original Parent ID`,lice_s$`Original ID`)]

lice_nhm$family <- lice_gen$family[match(lice_nhm$genus,lice_gen$genus)]
lice_nhm$family[which(lice_nhm$family=="Anoplura")] <- NA

lice_nhm <- lice_nhm[,c("id","accid","family","canonical","Authority","Usage","genus", "species",
                        "subspecies","Reference", "URL")]
names(lice_nhm) <- c("id","accid","family","canonical","authyear","status","genus", "species",
                     "subspecies","reference", "url")
lice_nhm$source <- "NHM"

write.csv(lice_nhm,"output\\Lice_NHM_taxo.csv",row.names = F)

rm(list=c("lice_ac","lice_gen","lice","lice_s","lice_sp","lice_syn"))

