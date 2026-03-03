#' Tokenize Source Document
#'
#' This function tokenizes a source document that is to be used in
#' [collocate_comments_fuzzy()] or [collocate_comments()]
#'
#' @param transcript_file data frame of the source document, where the source document text
#' is in a column named text.
#'
#' @return a tokenized object
#' @export
#'
#' @examples
#' # Tokenize source document
#' toks_source <- tokenize_source(transcript_example)

tokenize_source <- function(transcript_file){
  `%>%` <- magrittr::`%>%`
  description_df <- transcript_file
  description_df <- gsub("<.*?>", " ", description_df) #removing all html expressions
  description_df <- gsub("\\\\n", " ", description_df) #removing line breaks
  description_df <- stringi::stri_trans_general(description_df, "latin-ascii")
  description_df <- gsub("\\$", " ", description_df) #removing dollar sign
  description_df <- gsub("-", " ", description_df) #removing dash with space
  description_df <- gsub(":", "", description_df) #removing colon without space
  description_df <- gsub("([[:alnum:]])(\\.)([[:alnum:]])","\\1\\3", description_df) #removing period between characters
  description_df <- gsub("([[:alnum:]])(,)([[:alnum:]])","\\1\\3", description_df) #removing comma between characters
  description_df <- tolower(description_df)

  corpus_descript <- quanteda::corpus(description_df) #creating a corpus

  toks_des <- quanteda::tokens(corpus_descript, remove_punct = TRUE) #tokenizing transcript
  return(toks_des)
}
