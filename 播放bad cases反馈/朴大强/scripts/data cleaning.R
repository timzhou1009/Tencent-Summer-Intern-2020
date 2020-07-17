library(dplyr)

dat <- readxl::read_xlsx("~/Desktop/Tencent/7月第2周/播放bad cases反馈/朴大强/data/朴大强 召回排查.xlsx")

dat2 <- as.data.frame(dat[, 3:13])

dat2[,-1] <- as.numeric(dat2[,-1])

result <- dat2 %>% group_by(召回源) %>% sum() 
  
  
  mutate("总播放量" = sum(.$播放量))
