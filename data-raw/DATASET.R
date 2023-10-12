## code to prepare `DATASET` dataset goes here

library(readr)
library(dplyr)
comment_full<- read_csv("~/PhD Research/comment_example_highlightr.csv")
comment_example <- comment_full %>% filter(page_count==2 & page_notes !="") %>%
  select(clean_prints, page_notes) %>% rename("ID"="clean_prints", "Notes"="page_notes")

usethis::use_data(comment_example, overwrite = TRUE)
