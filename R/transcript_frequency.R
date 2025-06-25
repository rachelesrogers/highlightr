#' Mapping Collocation Frequency to Transcript Document
#'
#' This function connects the collocation frequency calculated in
#' [collocate_comments_fuzzy()] to the base transcript.
#'
#' @param transcript transcript document
#' @param collocate_object collocation object (returned
#' from [collocate_comments_fuzzy()] or [collocate_comments()])
#'
#' @return a dataframe of the transcript document with collocation values by word
#' @export
#'
#' @examples comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
#' toks_comment <- token_comments(comment_example_rename)
#' transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
#' toks_transcript <- token_transcript(transcript_example_rename)
#' collocation_object <- collocate_comments(toks_transcript, toks_comment)
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

  merged$Freq <- rowSums(merged[,grep("col_",colnames(collocate_object), value=TRUE)],
                         na.rm=TRUE)/rowSums(!is.na(merged[,grep("col_",colnames(collocate_object), value=TRUE)]))

  merged_final<- dplyr::left_join(descript_words, merged)

  return(merged_final)
}

transcript_cleaning <- function(transcript){
  `%>%` <- magrittr::`%>%`
  text <- lines <- words <- to_merge <- NULL

  poem <- transcript %>% tibble::tibble(lines = text) %>%
    # This looks for a letter + a space (of any sort, so an end-line counts) or
    # punctuation (last word of a line ends with e.g. a period or comma)
    dplyr::mutate(n_words = stringr::str_count(lines, "([A-z][[:space:][:punct:]])"))

  poem$lines <- stringi::stri_trans_general(poem$lines, "latin-ascii")
  poem$lines <- gsub("([^ ])(<)", "\\1 \\2", poem$lines)
  poem$lines <- gsub("< ", "<", poem$lines)
  poem$lines <- gsub("-", " - ", poem$lines) #replacing dash with space
  poem$lines <- gsub("\\.\\.\\.", "\\.\\.\\. ", poem$lines) #adding space after 3 dots
  poem$lines <- gsub(" \\.\\.\\.", "\\.\\.\\.", poem$lines) #removing space before 3 dots
  poem$lines <- gsub(" \\.", "\\.", poem$lines) #removing space before 1 dot
  poem$lines <- gsub("(>)([^ ])", "\\1 \\2", poem$lines)
  poem$lines <- gsub("([[:alnum:]])(/)","\\1 \\2", poem$lines)
  poem$lines <- stringi::stri_trans_general(poem$lines, "latin-ascii")

  poem_words <- poem %>%
    dplyr::mutate(words = stringr::str_split(lines, "[[:space:]]", simplify = F)) %>%
    tidyr::unnest(c(words)) %>%
    # Require words to have some non-space character
    dplyr::filter(nchar(stringr::str_trim(words)) > 0) %>%
    dplyr::mutate(word_num = 1:dplyr::n())

  # counting the number of characters
  poem_words$word_length<-nchar(poem_words$words)

  poem_words$x_coord <- NA
  # Assigning coordinates to be used for plotting
  for (i in 1:length(poem_words$n_words)){
    if (poem_words$word_num[i] == 1){
      poem_words$x_coord[i] = 1
    }
    else {
      poem_words$x_coord[i] = poem_words$x_coord[i-1]+poem_words$word_length[i-1]*2
    }
  }
  poem_words$to_merge<- tolower(poem_words$words)
  poem_words$to_merge<- gsub("<.*?>","", poem_words$to_merge)
  poem_words$to_merge<- tm::removePunctuation(poem_words$to_merge)

  group_exp <- poem_words %>%
    dplyr::group_by(to_merge) %>%
    dplyr::summarize(stanza_freq=dplyr::n()) %>%
    dplyr::ungroup()

  poem_words <- dplyr::right_join(poem_words, group_exp)


  return(poem_words)
}
