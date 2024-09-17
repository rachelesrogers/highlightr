#' Tokenize Transcript
#'
#' This function tokenizes a transcript document that is to be used in
#' [collocate_comments_fuzzy()] or [collocate_comments()]
#'
#' @param transcript_file data frame of the transcript, where the transcript text
#' is in a column named text.
#'
#' @return a tokenized object
#' @export
#'
#' @examples transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
#' toks_transcript <- token_transcript(transcript_example_rename)

token_transcript <- function(transcript_file){
  `%>%` <- magrittr::`%>%`
  description_df <- transcript_file
  description_df <- purrr::map_df(description_df, ~ gsub("<.*?>", " ", .x)) #removing all html expressions
  description_df <- purrr::map_df(description_df, ~ gsub("\\\\n", " ", .x)) #removing line breaks
  description_df <- purrr::map_df(description_df, ~stringi::stri_trans_general(.x, "latin-ascii"))
  description_df <- purrr::map_df(description_df, ~ gsub("\\$", " ", .x)) #removing dollar sign
  description_df <- purrr::map_df(description_df, ~ gsub("-", " ", .x)) #removing dash with space
  description_df <- purrr::map_df(description_df, ~ gsub(":", "", .x)) #removing colon without space
  description_df <- purrr::map_df(description_df, ~ gsub("([[:alnum:]])(\\.)([[:alnum:]])","\\1\\3", .x)) #removing period between characters
  description_df <- purrr::map_df(description_df, ~ gsub("([[:alnum:]])(,)([[:alnum:]])","\\1\\3", .x)) #removing comma between characters
  description_df <- tolower(description_df)

  corpus_descript <- quanteda::corpus(description_df) #creating a corpus

  toks_des <- quanteda::tokens(corpus_descript, remove_punct = TRUE) #tokenizing transcript
  return(toks_des)
}
