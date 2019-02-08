library(readr)
library(tidyr)
library(stringr)

all.files <- dir('data')

all.data <- NA
for(f in all.files){
  subject <- f %>% stringr::str_sub(start=1,end=2)
  condition <- f %>% stringr::str_extract("([A-Z])\\w+")
  file.data <- read_table2(paste0('data/',f), col_names = as.character(1:129))
  file.data$t <- -100:999
  file.data.tidy <- file.data %>% gather(key="electrode", value=voltage, 1:129)
  file.data.tidy$subject <- subject
  file.data.tidy$condition <- condition
  if(is.na(all.data)){
    all.data <- file.data.tidy
  } else {
    all.data <- rbind(all.data, file.data.tidy)
  }
}

# normally I would prefer to save as CSV since it is more portable,
# but the CSV file is > 100MB which makes data sync with GitHub difficult.

# write_csv(all.data, path="data/voltage_data_tidy.csv")

# so I will use .Rdata format instead, which has much better compression.
save(all.data, file="data/voltage_data.tidy.Rdata")

# behavioral data ####
beh.data <- read_csv('data/behavioral_data.csv')

beh.data.tidy <- beh.data %>% gather(Condition, CorrectReponses, 2:4)

write_csv(beh.data.tidy, path="data/behavioral_data_tidy.csv")
