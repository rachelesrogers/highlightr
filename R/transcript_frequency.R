#' Counts frequency of collocations within the transcript itself
#'
#' @param filelocation location of transcript file
#' @param page_number page number of transcript under consideration
#' @param collocate_object collocated comments from collocate_comments or collocate_comments_fuzzy
#'
#' @return
#' @export
#'
#' @examples
transcript_frequency <- function(filelocation, page_number, collocate_object){
  descript_words <- transcript_cleaning(readLines(filelocation), breaks="quote")

  descript_words_tomerge <- descript_words[descript_words$stanza== page_number,]

  descript_words_tomerge[descript_words_tomerge$words %in% c("-"," ","Q:","A:","Court:","Defense:","Prosecution:","\"Q:"), ]$to_merge<-""
  #descript_words_tomerge[descript_words_tomerge$lines=="Test-fired bullets admitted into evidence---", ]$to_merge<-""

  descript_words_tomerge_filtered <- descript_words_tomerge # %>% filter(!(words %in% c("-"," ","Q:","A:","Court:","Defense:","Prosecution:","\"Q:")))

  descript_words_tomerge_filtered$word_number<-NA
  descript_words_tomerge_filtered[descript_words_tomerge_filtered$to_merge!="",]$word_number <-
    seq(from=1, to=dim(descript_words_tomerge_filtered[descript_words_tomerge_filtered$to_merge!="",])[1])

  collocate_object$to_merge <- gsub("'","",collocate_object$to_merge)
  collocate_object$to_merge <- gsub("\\.","",collocate_object$to_merge)
  collocate_object$to_merge <- gsub("-","",collocate_object$to_merge)

  merged <- left_join(descript_words_tomerge_filtered, collocate_object, by=c("word_number","to_merge"))

  merged$Freq <- rowSums(merged[,c("col_1","col_2","col_3","col_4","col_5")], na.rm=TRUE)/rowSums(!is.na(merged[,c("col_1","col_2","col_3","col_4","col_5")]))

  merged_final<- left_join(descript_words_tomerge, merged)

  return(merged_final)
}
