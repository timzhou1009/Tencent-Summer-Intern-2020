dat1 <- read.csv("~/Desktop/Tencent/7月第3周/熔断分析/data/data.csv")
dat2 <- read.csv("~/Desktop/Tencent/7月第3周/熔断分析/data/二级类目大盘数据.csv")

library(dplyr)

dat1 <- dat1 %>% left_join(dat2, by = "cate2")
write.csv(dat1,"熔断分析.csv")
