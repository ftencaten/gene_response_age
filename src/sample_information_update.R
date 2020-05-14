drivephenodata <- read.delim("~/Downloads/sample_information (2).txt")

sex <- read.delim('sex_definition.txt')

localphenodata <- read.delim("data/phenodata.txt")

phenodata_batch1 <- read.delim("data/phenodata_batch1.tsv")

gambia <- read.delim("data/GAMBIA_Master_data_05-02-2020.tsv")

simon <- read.delim("data/SOURCE_VOL_META_all_SimonData.txt")

x <- merge(drivephenodata, localphenodata[,c(1,5)], by='label', all=T)

x[x$timepoint != "baseline", 6] <- "curettage"

y <- merge(x, sex, by="label",all=T)

#Gambia18
gambia$newsubid1 <- gsub("$","_V0",gambia$subid1)
gambia <- gambia[gambia$newsubid1 %in% y$label,]
y[y$label %in% gambia$newsubid1, 7] == gambia[,5]

#Simon data
simon <- simon[simon$Volunteer %in% y$label,]
y[y$label %in% simon$Volunteer,7] == as.vector(simon[,3])


write.table(y, here("data","sample_information.txt"), sep='\t',quote = F, row.names=F)
