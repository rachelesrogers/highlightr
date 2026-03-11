#' Tokenize Source Document
#'
#' This function tokenizes a source document that is to be used in
#' [collocation_frequency()]
#'
#' @param tbl data frame containing documents, where each
#' row represents a document
#' @param source_row row containing text to be treated as source
#' @param text_column string indicating the name of the column containing derivative text
#'
#' @return a tokenized object
#' @export
#'
#' @examples
#' # Tokenize source document
#' src_row <- which(notepad_example$ID=="source")
#' toks_source <- tokenize_source(notepad_example, source_row=src_row, text_column = "Text")

tokenize_source <- function(tbl, source_row, text_column){
  `%>%` <- magrittr::`%>%`

  source <- data.frame(tbl[source_row,])
  colnames(source) <- colnames(tbl)

  description_df <- source[[text_column]]
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
