#' Tokenize Transcript
#'
#' @param filelocation data frame of the transcript
#'
#' @return a tokenized object
#' @export
#'
#' @examples transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
#' toks_transcript <- token_transcript(transcript_example_rename)

token_transcript <- function(transcript_file){
  `%>%` <- magrittr::`%>%`
  description_df <- transcript_file
  description_df <- purrr::map_df(description_df, ~ gsub("<.*?>", "", .x)) #removing all html expressions
  description_df <- purrr::map_df(description_df, ~ gsub("\\\\n", "", .x)) #removing line breaks

  # description_df <- map_df(description_df, ~ gsub("---Test-fired bullets admitted into evidence---", "", .x))

  corpus_descript <- quanteda::corpus(description_df) #creating a corpus

  toks_des <- quanteda::tokens(corpus_descript, remove_punct = TRUE) #tokenizing transcript
  return(toks_des)
}
