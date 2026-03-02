#' Tokenize comments
#'
#' This function tokenizes comments that are to be used in [collocate_comments_fuzzy()]
#' or [collocate_comments()]
#'
#' @param derivative_document data frame containing derivative documents, where each
#' row represents a document
#' @param text_column string indicating the name of the column containing derivative text
#'
#' @return tokenized comments
#' @export
#'
#' @examples
#' # Rename relevant column to page_notes in the derivative document
#' comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
#' # Tokenize the derivative document
#' toks_comment <- tokenize_derivative(comment_example, text_column="Notes")

tokenize_derivative <- function(derivative_document, text_column){

  comment_df <- data.frame(docid = cbind(seq(1:dim(derivative_document)[1])),
                           text=tolower(derivative_document[[text_column]])) #lowercasing text

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
