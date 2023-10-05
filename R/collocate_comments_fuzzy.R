#' Collocate Comments Fuzzy
#'
#' @param transcript_token transcript token to act as baseline for notes
#' @param note_token tokenized document of notes
#'
#' @return data frame of transcript and corresponding note frequency
#' @export
#'
#' @examples
collocate_comments_fuzzy <- function(transcript_token, note_token){
  #Same as previous notes
  descript_ngrams <- tokens_ngrams(transcript_token, n = 5L, skip = 0L, concatenator = " ")
  descript_ngram_df <- data.frame(tolower(unlist(descript_ngrams)))
  rel_freq <-as.data.frame(table(descript_ngram_df))
  descript_ngram_df <- left_join(descript_ngram_df, rel_freq)
  names(descript_ngram_df) <- c("collocation", "transcript_freq")
  descript_ngram_df <-data.frame(collocation = descript_ngram_df$collocation,
                                 transcript_freq = descript_ngram_df$transcript_freq,
                                 word_1 = seq(from = 1, to = dim(descript_ngram_df)[1]),
                                 word_2 = seq(from = 2, to = (dim(descript_ngram_df)[1]+1)),
                                 word_3 = seq(from = 3, to = (dim(descript_ngram_df)[1]+2)),
                                 word_4 = seq(from = 4, to = (dim(descript_ngram_df)[1]+3)),
                                 word_5 = seq(from = 5, to = (dim(descript_ngram_df)[1]+4)))
  descript_ngram_df$first_word <- word(descript_ngram_df$collocation,1)

  #descript_ngram_df$collocation <- map_df(descript_ngram_df$collocation, ~ gsub("-","",.x))

  col_descript <- note_token %>% textstat_collocations(min_count = 1, size=5)
  #col_descript$collocation <- tolower(col_descript$collocation)

  col_merged_descript <- left_join(descript_ngram_df, col_descript)
  col_merged_descript$count <- replace(col_merged_descript$count,is.na(col_merged_descript$count),0)

  ###Fuzzy Matching

  # Finding collocations that do not directly match the transcript
  mismatches <- anti_join(col_descript, descript_ngram_df)

  fuzzy_matches <-stringdist_join(descript_ngram_df, mismatches,
                                  by='collocation', #match based on collocation
                                  mode='right', #use right join
                                  method = "lv", #use levenshtein distance metric
                                  max_dist=99,
                                  distance_col='dist')%>%
    group_by(collocation.y) %>%
    slice_min(order_by=dist, n=1) #finding the closest match
  #counting the number of closest matches per collocation
  close_freq<-as.data.frame(table(fuzzy_matches$collocation.y))
  close_freq <- close_freq %>% rename("collocation.y"="Var1", "close_freq"="Freq")

  fuzzy_matches <- left_join(fuzzy_matches, close_freq)

  #Fuzzy matches weight
  fuzzy_matches$weighted_count <- fuzzy_matches$count/((fuzzy_matches$dist+0.25)*fuzzy_matches$close_freq)

  #Counting up the number of fuzzy matches per transcript collocation
  fuzzy_col <-fuzzy_matches %>% group_by(collocation.x) %>%
    summarise (fuzzy_count = sum(weighted_count))

  fuzzy_col <- fuzzy_col %>% rename("collocation"="collocation.x")

  col_merged_fuzzy <- left_join(col_merged_descript, fuzzy_col)
  col_merged_fuzzy$fuzzy_count <- replace(col_merged_fuzzy$fuzzy_count, is.na(col_merged_fuzzy$fuzzy_count),0)
  #Counting up fuzzy and non-fuzzy matches
  col_merged_fuzzy$final_count <- col_merged_fuzzy$count+col_merged_fuzzy$fuzzy_count

  col_descript_long <- col_merged_fuzzy %>%  pivot_longer(cols = 3:7,
                                                          names_to = "col_number",
                                                          names_prefix = "word_",
                                                          values_to = "word_number"
  )
  col_descript_long$rel_freq <- col_descript_long$final_count/col_descript_long$transcript_freq

  descript_tomerge <- col_descript_long %>% select(rel_freq, col_number, word_number) %>%
    pivot_wider(names_from = col_number, values_from = rel_freq, names_prefix = "col_")

  add_word<-descript_ngram_df %>% select(word_1, first_word, collocation) %>% rename("word_number"="word_1")

  descript_tomerge <- left_join(descript_tomerge, add_word)
  descript_tomerge<-descript_tomerge %>% rename("to_merge"="first_word")

  descript_tomerge[dim(descript_tomerge)[1]-3,]$to_merge <-
    word(descript_tomerge[dim(descript_tomerge)[1]-4,]$collocation,2)
  descript_tomerge[dim(descript_tomerge)[1]-2,]$to_merge <-
    word(descript_tomerge[dim(descript_tomerge)[1]-4,]$collocation,3)
  descript_tomerge[dim(descript_tomerge)[1]-1,]$to_merge <-
    word(descript_tomerge[dim(descript_tomerge)[1]-4,]$collocation,4)
  descript_tomerge[dim(descript_tomerge)[1],]$to_merge <-
    word(descript_tomerge[dim(descript_tomerge)[1]-4,]$collocation,5)

  return(descript_tomerge)

}
