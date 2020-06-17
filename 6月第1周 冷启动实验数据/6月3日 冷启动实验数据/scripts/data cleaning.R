setwd("~/Downloads")
library(dplyr)

two <- read.csv('分作者等级看发文留存 2日.csv')
three <- read.csv('分作者等级看发文留存 3日.csv')
seven <- read.csv('分作者等级看发文留存 7日.csv')
dat <- two %>% 
  inner_join(three, by = c("expid", "priority", "pugc")) %>% 
  inner_join(seven, by = c("expid", "priority", "pugc")) %>% 
  select(expid, priority, pugc, 
         "two" = person_repost_within.x, 
         "three" = person_repost_within.y, 
         "seven" = person_repost_within) %>% write.csv("分作者等级看发文留存.csv")

