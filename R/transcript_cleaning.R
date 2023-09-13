#' Title
#'
#' @param transcript
#' @param breaks
#'
#' @return
#' @export
#'
#' @examples


transcript_cleaning <- function(transcript, breaks="blanklines"){
  # Code from Dr. Vanderplas' 850 class
  poem <- tibble(lines = transcript) %>%
    # This looks for a letter + a space (of any sort, so an end-line counts) or
    # punctuation (last word of a line ends with e.g. a period or comma)
    mutate(n_words = str_count(lines, "([A-z][[:space:][:punct:]])"))

  poem$lines <- gsub("/"," ",  poem$lines)
  poem$lines <- gsub("<.*?>", "", poem$lines)
  poem$lines <- poem$lines  %>% str_replace("<center>", "")  %>% str_replace("---","") # %>%

  if (breaks == "quote"){
    poem <- poem %>% mutate(stanza=cumsum(grepl("^\"[A-z]", lines)))
  } else if (breaks == "blanklines"){
    poem <- poem %>% mutate(stanza = cumsum(n_words == 0) + 1)
  }

  poem <- poem %>%
    # Now we can get rid of lines with 0 words
    filter(n_words > 0) %>%
    mutate(overall_line = 1:n()) %>%
    # We can group by stanza and count the lines within each stanza
    group_by(stanza) %>%
    mutate(stanza_line = 1:n())

  poem_words <- poem %>%
    mutate(words = str_split(lines, "[[:space:]]", simplify = F)) %>%
    unnest(c(words)) %>%
    # Require words to have some non-space character
    filter(nchar(str_trim(words)) > 0) %>%
    # For each line, group by line number and calculate the word number
    group_by(overall_line) %>%
    filter(!(words %in% c("<br", "><br", ">"))) %>%
    mutate(word_num = 1:n())

  # Removing html break marks
  poem_words$words<-gsub("</br>","", poem_words$words)
  poem_words$words<-gsub( "<br/>","", poem_words$words)

  # counting the number of characters
  poem_words$word_length<-nchar(poem_words$words)

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
  poem_words$to_merge<-removePunctuation(poem_words$to_merge)

  group_exp <- poem_words %>%
    group_by(stanza, to_merge) %>%
    summarize(stanza_freq=n()) %>%
    ungroup()

  poem_words <- right_join(poem_words, group_exp)


  return(poem_words)
}
