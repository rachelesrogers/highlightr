#' Tokenize comments
#'
#' This function tokenizes comments that are to be used in [collocation_frequency()]
#'
#' @param tbl data frame containing documents, where each
#' row represents a document
#' @param source_row row containing text to be treated as source
#' @param text_column string indicating the name of the column containing derivative text
#'
#' @return tokenized comments
#' @export
#'
#' @examples
#' # Tokenize the derivative document
#' src_row <- which(notepad_example$ID=="source")
#' toks_comment <- tokenize_derivative(notepad_example, source_row=src_row, text_column="Text")

tokenize_derivative <- function(tbl, source_row, text_column){

  derivatives <- data.frame(tbl[-source_row,])
  colnames(derivatives) <- colnames(tbl)

  comment_df <- data.frame(docid = cbind(seq(1:nrow(derivatives))),
                           text=tolower(derivatives[[text_column]])) #lowercasing text

  comment_df <- purrr::map_df(comment_df, ~ gsub("<.*?>", " ", .x))
  comment_df <- purrr::map_df(comment_df, ~ gsub("\\$", " ", .x))
  comment_df <- purrr::map_df(comment_df, ~stringi::stri_trans_general(.x, "latin-ascii"))
  comment_df <- purrr::map_df(comment_df, ~ gsub("-", " ", .x)) #removing dash with space
  comment_df <- purrr::map_df(comment_df, ~ gsub(":", "", .x)) #removing colon without space
  comment_df <- purrr::map_df(comment_df, ~ gsub("([[:alnum:]])(\\.)([[:alnum:]])","\\1\\3", .x)) #removing period between characters
  comment_df <- purrr::map_df(comment_df, ~ gsub("([[:alnum:]])(,)([[:alnum:]])","\\1\\3", .x)) #removing comma between characters

  corpus_doc <- quanteda::corpus(comment_df)

  toks_doc <- quanteda::tokens(corpus_doc, remove_punct = TRUE)
  return(toks_doc)
}
