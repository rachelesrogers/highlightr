#' Collocation of Comments
#'
#' This function provides the frequency of collocations in comments that
#' correspond to the provided transcript.
#'
#' @param transcript_token transcript token to act as baseline for notes, resulting
#' from [token_transcript()]
#' @param note_token tokenized document of notes, resulting from [token_comments()]
#' @param collocate_length the length of the collocation. Default is 5
#'
#' @return data frame of the transcript and corresponding note frequency
#' @export
#'
#' @examples comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
#' toks_comment <- token_comments(comment_example_rename[1:100,])
#' transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
#' toks_transcript <- token_transcript(transcript_example_rename)
#' collocation_object <- collocate_comments(toks_transcript, toks_comment)
#'
collocate_comments <- function(transcript_token, note_token, collocate_length=5){
  col_number <- word_number <- word_1 <- first_word <- collocation <- NULL
  `%>%` <- magrittr::`%>%`
  #Creating ngrams of length 5
  descript_ngrams <- quanteda::tokens_ngrams(transcript_token, n = collocate_length, skip = 0, concatenator = " ")
  descript_ngram_df <- data.frame(tolower(unlist(descript_ngrams)))
  rel_freq <-as.data.frame(table(descript_ngram_df)) #calculating frequency of ngrams
  descript_ngram_df <- dplyr::left_join(descript_ngram_df, rel_freq) #binding frequency to collocations
  names(descript_ngram_df) <- c("collocation", "transcript_freq")

  descript_ngram_df <-data.frame(collocation = descript_ngram_df$collocation,
                                 transcript_freq = descript_ngram_df$transcript_freq)
  for (i in 1:collocate_length){
    descript_ngram_df <- cbind(descript_ngram_df, seq(from=i, to = dim(descript_ngram_df)[1]+(i-1)))
    names(descript_ngram_df)[ncol(descript_ngram_df)]<-paste0("word_",i)
  }

  descript_ngram_df$first_word <- stringr::word(descript_ngram_df$collocation,1)

  #getting collocations from notes
  col_descript <- note_token %>% quanteda.textstats::textstat_collocations(min_count = 1,
                                                                           size=collocate_length)

  col_merged_descript <- dplyr::left_join(descript_ngram_df, col_descript)

  #replacing na's with 0's
  col_merged_descript$count <- replace(col_merged_descript$count,is.na(col_merged_descript$count),0)

  col_descript_long <- col_merged_descript %>%  tidyr::pivot_longer(cols = 3:(collocate_length+2),
                                                             names_to = "col_number",
                                                             names_prefix = "word_",
                                                             values_to = "word_number"
  )
  #calculating relative frequency based on number of times colloactions occur
  col_descript_long$rel_freq <- col_descript_long$count/col_descript_long$transcript_freq

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

  return(descript_tomerge)

}
