#' Mapping Collocation Frequency to Transcript Document
#'
#' @param transcript transcript document
#' @param collocate_object collocation object (returned from collocate_comments_fuzzy)
#'
#' @return a dataframe of the transcript document with collocation values
#' @export
#'
#' @examples comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
#' toks_comment <- token_comments(comment_example_rename)
#' transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
#' toks_transcript <- token_transcript(transcript_example_rename)
#' collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)
#' merged_frequency <- transcript_frequency(transcript_example_rename, collocation_object)

transcript_frequency <- function(transcript, collocate_object){
  descript_words <- transcript_cleaning(transcript)

  descript_words[descript_words$words %in% c("-"," "), ]$to_merge<-""

  descript_words$word_number<-NA
  descript_words[descript_words$to_merge!="",]$word_number <-
    seq(from=1, to=dim(descript_words[descript_words$to_merge!="",])[1])

  collocate_object$to_merge <- gsub("'","",collocate_object$to_merge)
  collocate_object$to_merge <- gsub("\\.","",collocate_object$to_merge)
  collocate_object$to_merge <- gsub("-","",collocate_object$to_merge)

  merged <- dplyr::left_join(descript_words, collocate_object, by=c("word_number","to_merge"))

  merged$Freq <- rowSums(merged[,c("col_1","col_2","col_3","col_4","col_5")], na.rm=TRUE)/rowSums(!is.na(merged[,c("col_1","col_2","col_3","col_4","col_5")]))

  merged_final<- dplyr::left_join(descript_words, merged)

  return(merged_final)
}
