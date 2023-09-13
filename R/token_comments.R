#' Tokenize comments
#'
#' @param comment_document document containing comments
#' @param page_number page number to be tokenized
#'
#' @return tokenized comments
#' @export
#'
#' @examples

token_comments <- function(comment_document, page_number){
  pg2 <- comment_document %>% subset(page_count == page_number) #finding comments for current page

  ######## Attempt to remove prompts ##########
  pg2$page_notes <- gsub("Q:", "", pg2$page_notes)
  pg2$page_notes <- gsub("A:", "", pg2$page_notes)
  pg2$page_notes <- gsub("Court:", "", pg2$page_notes)
  pg2$page_notes <- gsub("Defense:", "", pg2$page_notes)
  pg2$page_notes <- gsub("Prosecution:", "", pg2$page_notes)
  pg2$page_notes <- gsub("\"Q:", "", pg2$page_notes)
  ##############################################

  # pg2$page_notes <- gsub("---Test-fired bullets admitted into evidence---","",pg2$page_notes)

  pg2_df <- data.frame(docid = cbind(seq(1:dim(pg2)[1])), text=tolower(pg2$page_notes)) #lowercasing text
  #pg2_df <- map_df(pg2_df, ~ gsub("-","",.x))

  corpus_pg2 <- corpus(pg2_df)

  toks_pg2 <- tokens(corpus_pg2, remove_punct = TRUE)
  return(toks_pg2)
}
