library(dplyr)

dat <- read.csv("~/Desktop/Tencent/6月第4周/一键出片 功能排查/data/一键出片功能排查.txt", sep = " ")

dat$account_id <- format(dat$account_id, scientific = FALSE)

dat <- unique(dat)

write.csv(dat, "dat.csv")