#' Collocate Comments Fuzzy
#'
#' This function provides the frequency of collocations in comments that
#' correspond to the provided transcript, using fuzzy matching.
#'
#' @param transcript_token transcript token to act as baseline for notes, resulting
#' from [token_transcript()]
#' @param note_token tokenized document of notes, resulting from [token_comments()]
#' @param collocate_length the length of the collocation. Default is 5
#' @param n_bands number of bands used in MinHash algorithm passed to `zoomerjoin::jaccard_right_join()`. Default is 50
#' @param threshold considered a match in for Jaccard distance passed to `zoomerjoin::jaccard_right_join()`. Default is 0.7
#'
#' @return data frame of the transcript and corresponding note frequency
#' @export
#'
#' @examples comment_example_rename <- dplyr::rename(comment_example[1:10,], page_notes=Notes)
#' toks_comment <- token_comments(comment_example_rename)
#' transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
#' toks_transcript <- token_transcript(transcript_example_rename)
#' fuzzy_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)

collocate_comments_fuzzy <- function(transcript_token, note_token, collocate_length=5, n_bands=50, threshold=0.7){
  collocation.y <- dist <- collocation.x <- weighted_count <- col_number <- word_number <-
    word_1 <- first_word <- collocation <- NULL
  `%>%` <- magrittr::`%>%`
  #Same as previous notes
  descript_ngrams <- quanteda::tokens_ngrams(transcript_token, n = collocate_length, skip = 0L, concatenator = " ")
  descript_ngram_df <- data.frame(unlist(descript_ngrams))
  rel_freq <-as.data.frame(table(descript_ngram_df))
  descript_ngram_df <- dplyr::left_join(descript_ngram_df, rel_freq)
  names(descript_ngram_df) <- c("collocation", "transcript_freq")

  descript_ngram_df <-data.frame(collocation = descript_ngram_df$collocation,
                                 transcript_freq = descript_ngram_df$transcript_freq)
  for (i in 1:collocate_length){
    descript_ngram_df <- cbind(descript_ngram_df, seq(from=i, to = dim(descript_ngram_df)[1]+(i-1)))
    names(descript_ngram_df)[ncol(descript_ngram_df)]<-paste0("word_",i)
  }

  descript_ngram_df$first_word <- stringr::word(descript_ngram_df$collocation,1)

  col_descript <- note_token %>% quanteda.textstats::textstat_collocations(min_count = 1,
                                                                           size=collocate_length)

  col_merged_descript <- dplyr::left_join(descript_ngram_df, col_descript)
  col_merged_descript$count <- replace(col_merged_descript$count,is.na(col_merged_descript$count),0)

  ###Fuzzy Matching

  # Finding collocations that do not directly match the transcript
  mismatches <- dplyr::anti_join(col_descript, descript_ngram_df)

  fuzzy_matches <- zoomerjoin::jaccard_right_join(descript_ngram_df, mismatches,
                                                  by='collocation', similarity_column="dist", n_bands=n_bands, threshold=threshold)%>%
    dplyr::filter(!is.na(collocation.x)) %>%
    dplyr::group_by(collocation.y) %>%
    dplyr::slice_max(order_by=dist, n=1) #finding closest match based on Jaccard Distance
  #counting the number of closest matches per collocation
  if (dim(fuzzy_matches)[1] != 0){
  close_freq<-as.data.frame(table(fuzzy_matches$collocation.y))
  close_freq <- close_freq %>% dplyr::rename("collocation.y"="Var1", "close_freq"="Freq")

  fuzzy_matches <- dplyr::left_join(fuzzy_matches, close_freq)

  #Fuzzy matches weight
  fuzzy_matches$weighted_count <- (fuzzy_matches$count*fuzzy_matches$dist)/(fuzzy_matches$close_freq)

  #Counting up the number of fuzzy matches per transcript collocation
  fuzzy_col <-fuzzy_matches %>% dplyr::group_by(collocation.x) %>%
    dplyr::summarise (fuzzy_count = sum(weighted_count))

  fuzzy_col <- fuzzy_col %>% dplyr::rename("collocation"="collocation.x")

  col_merged_fuzzy <- dplyr::left_join(col_merged_descript, fuzzy_col)
  } else{
    col_merged_fuzzy <- col_merged_descript
    col_merged_fuzzy$fuzzy_count <- NA

  }
  col_merged_fuzzy$fuzzy_count <- replace(col_merged_fuzzy$fuzzy_count, is.na(col_merged_fuzzy$fuzzy_count),0)
  #Counting up fuzzy and non-fuzzy matches
  col_merged_fuzzy$final_count <- col_merged_fuzzy$count+col_merged_fuzzy$fuzzy_count

  col_descript_long <- col_merged_fuzzy %>%  tidyr::pivot_longer(cols = 3:(collocate_length+2),
                                                          names_to = "col_number",
                                                          names_prefix = "word_",
                                                          values_to = "word_number"
  )
  col_descript_long$rel_freq <- col_descript_long$final_count/col_descript_long$transcript_freq

  descript_tomerge <- col_descript_long %>% dplyr::select(rel_freq, col_number, word_number) %>%
    tidyr::pivot_wider(names_from = col_number, values_from = rel_freq, names_prefix = "col_")

  add_word<-descript_ngram_df %>% dplyr::select(word_1, first_word, collocation) %>%
    dplyr::rename("word_number"="word_1")

  descript_tomerge <- dplyr::left_join(descript_tomerge, add_word)
  descript_tomerge<-descript_tomerge %>% dplyr::rename("to_merge"="first_word")

  for (i in 2:collocate_length){
    descript_tomerge[dim(descript_tomerge)[1]-(collocate_length-i),]$to_merge <-
      stringr::word(descript_tomerge[dim(descript_tomerge)[1]-(collocate_length-1),]$collocation, i)
  }

  return(descript_tomerge)

}
