## code to prepare `DATASET` dataset goes here

library(readr)
library(dplyr)
comment_full<- read_csv("~/PhD Research/ResponseType_Survey/hybrid_response_dataset.csv")
comment_example <- comment_full %>% filter(page_count==2 & page_notes !="") %>%
  select(clean_prints, page_notes) %>% rename("ID"="clean_prints", "Notes"="page_notes")

comment_example <- purrr::map_df(comment_example, ~stringi::stri_trans_general(.x, "latin-ascii"))

usethis::use_data(comment_example, overwrite = TRUE)

transcript_full <- read_csv("~/PhD Research/ResponseType_Survey/Combined_Testimony_Formatted.csv")

transcript_example <- transcript_full %>% filter(Page==2) %>% select(Text)

transcript_example <- purrr::map_df(transcript_example, ~stringi::stri_trans_general(.x, "latin-ascii"))

usethis::use_data(transcript_example, overwrite = TRUE)
