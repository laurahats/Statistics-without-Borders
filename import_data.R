
library(tidyverse)
library(readxl)

setwd("~/My Documents/SWB/Chicago 400 Alliance/IL Prison Population Repository")

files <- (Sys.glob("*.xls"))

listOfFiles <- lapply(files, function(x) 
  read_excel(path=x,skip=5,trim_ws=TRUE,col_names=TRUE,
             col_types=c("text","text", "date", "text", "text", "text", "date",
                         "text", "text", "date", "date", "date", "date",
                         "text", "text", "text", "text", "text", "text"),
             ))


df <- bind_rows(listOfFiles, .id = "id")

#some will be in multiple files, get rid of complete duplicates(all values dup)
prison <- df %>% distinct()

table(prison$Name)
print("Count of repeated names")
which(table(prison$Name)>1)

problem <- prison %>% filter(table(prison$Name) > 1)



prison2 <- prison %>% arrange("Name")

check <- unique(prison$Name)

sort(check)
datac <- table(check)







