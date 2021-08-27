
library(tidyverse)
library(readxl)

#when on work comp
setwd("~/My Documents/SWB/Chicago 400 Alliance/IL Prison Population Repository")

#when on home comp
setwd("~/SWB Projects/Chicago 400 Alliance/IL Prision Population")

files <- (Sys.glob("*.xls"))

listOfFiles <- lapply(files, function(x) 
  read_excel(path=x,skip=6,trim_ws=TRUE,
             col_types=c("text","text", "date", "text", "text", "text", "date",
                         "text", "text", "date", "date", "date", "date",
                         "text", "text", "text", "text", "text", "text"),
             col_names=c("IDOC","Name","DOB","Sex","Race","Vetern Status",
                         "Current Admission Date","Admission Type","Parent Institution",
                         "Projected Mandatory Supervised Release (MSR) Date",
                         "Projected Discharge Date","Custody Date","Sentence Date",
                         "Crime Class","Holding Offense","Sentence Years","Sentence Months",
                         "Truth in Sentencing","Sentencing County")
  ))


df <- bind_rows(listOfFiles, .id = "id")

                      
setwd("~/SWB Projects/Chicago 400 Alliance/IL Prision Population/otherdateformat")

files2 <- (Sys.glob("*.xls"))

listOfFiles2 <- lapply(files2, function(x) 
  read_excel(path=x,skip=5,trim_ws=TRUE,
             col_types=c("text","text", "text", "text", "text", "text", "text",
                         "text", "text", "text", "text", "text", "text",
                         "text", "text", "text", "text", "text", "text"),
             col_names=c("IDOC","Name","DOB","Sex","Race","Vetern Status",
                         "Current Admission Date","Admission Type","Parent Institution",
                         "Projected Mandatory Supervised Release (MSR) Date",
                         "Projected Discharge Date","Custody Date","Sentence Date",
                         "Crime Class","Holding Offense","Sentence Years","Sentence Months",
                         "Truth in Sentencing","Sentencing County")
  ))

df2 <- bind_rows(listOfFiles2, .id = "id")

df2$'DOB' <- mdy(df2$'DOB')
df2$`Current Admission Date` <- mdy(df2$`Current Admission Date`)
df2$`Projected Mandatory Supervised Release (MSR) Date` <- mdy(df2$`Projected Mandatory Supervised Release (MSR) Date`)
df2$`Projected Discharge Date` <- mdy(df2$`Projected Discharge Date`)
df2$`Custody Date` <- mdy(df2$`Custody Date`)
df2$`Sentence Date` <- mdy(df2$`Sentence Date`)



#this needs work, skip for now
setwd("~/SWB Projects/Chicago 400 Alliance/IL Prision Population/otherdateformat3")

files3 <- (Sys.glob("*.xls"))

listOfFiles3 <- lapply(files3, function(x) 
  read_excel(path=x,skip=5,trim_ws=TRUE,col_names=TRUE,
             col_types=c("text","text", "text", "text", "text", "text", "text",
                         "text", "text", "text", "text", "text", "text",
                         "text", "text", "text", "text", "text", "text"),
  ))

df3 <- bind_rows(listOfFiles3, .id = "id")

df3$'Date of Birth' <- as.Date(df3$'Date of Birth',"%m%d%y")
df3$`Current Admission Date` <- as.Date(df3$`Current Admission Date`,"%m%d%y")
df3$`Projected Mandatory Supervised Release (MSR) Date2` <- as.Date(df3$`Projected Mandatory Supervised Release (MSR) Date2`,"%m%d%y")
df3$`Projected Discharge  Date2` <- as.Date(df3$`Projected Discharge  Date2`,"%m%d%y")
df3$`Custody Date` <- as.Date(df3$`Custody Date`,"%m%d%y")
df3$`Sentence Date` <- as.Date(df3$`Sentence Date`,"%m%d%y")



fulldf <- bind_rows(df,df2)            
                      
                      
#some will be in multiple files, get rid of duplicates by the identifiers
prison <- fulldf %>% select(-id) %>% 
              distinct(Name, DOB, Sex, Race)

prison2 <- prison %>% 
          group_by(Name, DOB, Sex, Race) %>%
          mutate(count=n()) %>%
          select(count,everything())
         
prison3 <- prison2 %>% filter(count>2)

prison4 <- prison2 %>% filter(Name=="ADAMS, ROBERT")
                       
View(prison4)                     
                 
                      
                      
                      
                      
table(prison$Name)
print("Count of repeated names")
which(table(prison$Name)>1)

problem <- prison %>% filter(table(prison$Name) > 1)



prison2 <- prison %>% arrange("Name")

check <- unique(prison$Name)

sort(check)
datac <- table(check)


