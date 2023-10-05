#' Collocation of Comments
#'
#' @param transcript_token transcript token to act as baseline for notes
#' @param note_token tokenized document of notes
#'
#' @return data frame of transcript and corresponding note frequency
#' @export
#'
#' @examples
collocate_comments <- function(transcript_token, note_token){
  #Creating ngrams of length 5
  descript_ngrams <- tokens_ngrams(transcript_token, n = 5L, skip = 0L, concatenator = " ")
  descript_ngram_df <- data.frame(tolower(unlist(descript_ngrams)))
  rel_freq <-as.data.frame(table(descript_ngram_df)) #calculating frequency of ngrams
  descript_ngram_df <- left_join(descript_ngram_df, rel_freq) #binding frequency to collocations
  names(descript_ngram_df) <- c("collocation", "transcript_freq")

  # numbering words in the collocation
  descript_ngram_df <-data.frame(collocation = descript_ngram_df$collocation,
                                 transcript_freq = descript_ngram_df$transcript_freq,
                                 word_1 = seq(from = 1, to = dim(descript_ngram_df)[1]),
                                 word_2 = seq(from = 2, to = (dim(descript_ngram_df)[1]+1)),
                                 word_3 = seq(from = 3, to = (dim(descript_ngram_df)[1]+2)),
                                 word_4 = seq(from = 4, to = (dim(descript_ngram_df)[1]+3)),
                                 word_5 = seq(from = 5, to = (dim(descript_ngram_df)[1]+4)))

  #descript_ngram_df$collocation <- map_df(descript_ngram_df$collocation, ~ gsub("-","",.x))

  #getting collocations from notes
  col_descript <- note_token %>% textstat_collocations(min_count = 1, size=5)
  #col_descript$collocation <- tolower(col_descript$collocation)

  col_merged_descript <- left_join(descript_ngram_df, col_descript)

  #replacing na's with 0's
  col_merged_descript$count <- replace(col_merged_descript$count,is.na(col_merged_descript$count),0)

  col_descript_long <- col_merged_descript %>%  pivot_longer(cols = 3:7,
                                                             names_to = "col_number",
                                                             names_prefix = "word_",
                                                             values_to = "word_number"
  )
  #calculating relative frequency based on number of times colloactions occur
  col_descript_long$rel_freq <- col_descript_long$count/col_descript_long$transcript_freq

  descript_tomerge <- col_descript_long %>% select(rel_freq, col_number, word_number) %>%
    pivot_wider(names_from = col_number, values_from = rel_freq, names_prefix = "col_")

  return(descript_tomerge)

}
