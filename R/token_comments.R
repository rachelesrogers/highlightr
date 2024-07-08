#' Tokenize comments
#'
#' This function tokenizes comments that are to be used in [collocate_comments_fuzzy()]
#' or [collocate_comments()]
#'
#' @param comment_document document containing notes by individual, where the
#' column containing the notes is named page_notes
#'
#' @return tokenized comments
#' @export
#'
#' @examples comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
#' toks_comment <- token_comments(comment_example_rename)

token_comments <- function(comment_document){

  comment_df <- data.frame(docid = cbind(seq(1:dim(comment_document)[1])),
                           text=tolower(comment_document$page_notes)) #lowercasing text

  comment_df <- purrr::map_df(comment_df, ~ gsub("<.*?>", " ", .x))

  corpus_doc <- quanteda::corpus(comment_df)

  toks_doc <- quanteda::tokens(corpus_doc, remove_punct = TRUE)
  return(toks_doc)
}
