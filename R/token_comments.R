#' Tokenize comments
#'
#' @param comment_document document containing comments
#'
#' @return tokenized comments
#' @export
#'
#' @examples comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
#' toks_comment <- token_comments(comment_example_rename)

token_comments <- function(comment_document){

  comment_df <- data.frame(docid = cbind(seq(1:dim(comment_document)[1])),
                           text=tolower(comment_document$page_notes)) #lowercasing text

  corpus_doc <- quanteda::corpus(comment_df)

  toks_doc <- quanteda::tokens(corpus_doc, remove_punct = TRUE)
  return(toks_doc)
}