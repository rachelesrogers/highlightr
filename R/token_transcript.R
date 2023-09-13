#' Tokenize Transcript
#'
#' @param filelocation location of the file to be tokenized
#'
#' @return a tokenized object
#' @export
#'
#' @example

token_transcript <- function(filelocation){
  description_txt<-read.table(filelocation)
  description_df <- as.data.frame(cbind(seq(1:dim(description_txt)[1]), description_txt))

  colnames(description_df) <- c("docid", "text")
  description_df <- map_df(description_df, ~ gsub("<.*?>", "", .x)) #removing all html expressions
  description_df <- map_df(description_df, ~ gsub("\\\\n", "", .x)) #removing line breaks

  ###### Attempting to Remove Question Prompts ############
  description_df <- map_df(description_df, ~ gsub("Q:", "", .x)) #removing word indicators
  description_df <- map_df(description_df, ~ gsub("A:", "", .x)) #removing word indicators
  description_df <- map_df(description_df, ~ gsub("Court:", "", .x)) #removing word indicators
  description_df <- map_df(description_df, ~ gsub("Defense:", "", .x)) #removing word indicators
  description_df <- map_df(description_df, ~ gsub("Prosecution:", "", .x)) #removing word indicators
  description_df <- map_df(description_df, ~ gsub("\"Q:", "", .x)) #removing word indicators
  #########################################################

  # description_df <- map_df(description_df, ~ gsub("---Test-fired bullets admitted into evidence---", "", .x))

  corpus_descript <- corpus(description_df) #creating a corpus

  toks_des <- tokens(corpus_descript, remove_punct = TRUE) #tokenizing transcript
  return(toks_des)
}
