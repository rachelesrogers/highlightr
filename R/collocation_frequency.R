#' Mapping Collocation Frequency to Source Document
#'
#' This function provides the frequency of collocations in comments that
#' correspond to the provided source document.
#'
#' Collocations are sequences of words present in the source document.
#' For example, the phrase "the blue bird flies" contains one collocation of
#' length 4 ("the blue bird flies"), two collocations of length 3 ("the blue bird"
#' and "blue bird flies"), and three collocations of length 2 ("the blue",
#' "blue bird", and "bird flies").
#' This function counts the number of corresponding phrases in the 'notes', or the
#' derivative documents.
#' When fuzzy matching is included, indirect matches are included with a weight of
#' (n*d)/m, where n is the frequency of the fuzzy collocation,
#' d is the Jaccard similarity between the transcript and note collocation, and m
#' is the number of closest matches for the note collocation.
#'
#' @param tbl data frame containing documents, where each
#' row represents a document
#' @param source_row row containing text to be treated as source
#' @param text_column string indicating the name of the column containing derivative text
#' @param fuzzy whether or not to use fuzzy matching in collocation calculations
#' @param collocate_length the length of the collocation. Default is 5
#' @param n_bands number of bands used in MinHash algorithm passed to `zoomerjoin::jaccard_right_join()`. Default is 50
#' @param threshold Jaccard distance threshold to be considered a match passed to `zoomerjoin::jaccard_right_join()`. Default is 0.7
#' @param n_gram_width width of n-grams used in Jaccard distance calculation passed to `zoomerjoin::jaccard_right_join()`. Default is 4
#'
#' @return a dataframe of the transcript document with collocation values by word
#' @export
#'
#' @examples
#' src_row <- which(notepad_example$ID=="source")
#' merged_frequency <- collocation_frequency(notepad_example, src_row, "Text")

collocation_frequency <- function(tbl, source_row, text_column,
                                  collocate_length=5, fuzzy=FALSE, n_bands=50,
                                  threshold=0.7, n_gram_width=4){

  `%>%` <- magrittr::`%>%`
  transcript_token <- tokenize_source(tbl=tbl, source_row=source_row, text_column = text_column)
  note_token <- tokenize_derivative(tbl=tbl, source_row=source_row, text_column = text_column)

  source_doc <- data.frame(tbl[source_row,])
  colnames(source_doc) <- colnames(tbl)
  transcript <- source_doc[[text_column]]


  if (fuzzy == TRUE){
    collocate_object <-
      collocate_comments_fuzzy(transcript_token=transcript_token, note_token=note_token,
                               collocate_length=collocate_length, n_bands=n_bands,
                               threshold=threshold, n_gram_width=n_gram_width)
  }else{
    collocate_object <-
      collocate_comments(transcript_token, note_token, collocate_length=collocate_length)
  }


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

  merged_final<- dplyr::left_join(descript_words, merged, by = c("Text", "lines", "n_words",
                                  "words", "word_num", "word_length", "x_coord",
                                  "to_merge", "stanza_freq", "word_number"))

  reduced_merged <- merged_final %>% dplyr::select(!c("Text", "lines", "n_words", "word_length", "stanza_freq"))

  return(reduced_merged)
}

transcript_cleaning <- function(transcript){
  `%>%` <- magrittr::`%>%`
  text <- lines <- words <- to_merge <- NULL

  poem <- transcript %>% tibble::tibble(lines = transcript) %>%
    # This looks for a letter + a space (of any sort, so an end-line counts) or
    # punctuation (last word of a line ends with e.g. a period or comma)
    dplyr::mutate(n_words = stringr::str_count(lines, "([A-z][[:space:][:punct:]])"))

  poem$lines <- stringi::stri_trans_general(poem$lines, "latin-ascii")
  poem$lines <- gsub("([^ ])(<)", "\\1 \\2", poem$lines)
  poem$lines <- gsub("< ", "<", poem$lines)
  poem$lines <- gsub("-", " - ", poem$lines) #replacing dash with space
  poem$lines <- gsub("\\.\\.\\.", "\\.\\.\\. ", poem$lines) #adding space after 3 dots
  poem$lines <- gsub(" \\.\\.\\.", "\\.\\.\\.", poem$lines) #removing space before 3 dots
  poem$lines <- gsub("( \\.)([[:alnum:]])", " \\2", poem$lines) #removing dot before characters
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
  poem_words[poem_words$words %in% c("+","="),]$to_merge <-  poem_words[poem_words$words %in% c("+","="),]$words

  group_exp <- poem_words %>%
    dplyr::group_by(to_merge) %>%
    dplyr::summarize(stanza_freq=dplyr::n()) %>%
    dplyr::ungroup()

  poem_words <- dplyr::right_join(poem_words, group_exp, by="to_merge")
  colnames(poem_words)[1] <- 'Text'


  return(poem_words)
}

collocate_comments <- function(transcript_token, note_token, collocate_length=5){
  col_number <- word_number <- word_1 <- first_word <- collocation <- NULL
  `%>%` <- magrittr::`%>%`
  #Creating ngrams of length 5
  descript_ngrams <- quanteda::tokens_ngrams(transcript_token, n = collocate_length, skip = 0, concatenator = " ")
  descript_ngram_df <- data.frame(tolower(unlist(descript_ngrams)))
  rel_freq <-as.data.frame(table(descript_ngram_df)) #calculating frequency of ngrams
  descript_ngram_df <- dplyr::left_join(descript_ngram_df, rel_freq, by = "tolower.unlist.descript_ngrams..") #binding frequency to collocations
  names(descript_ngram_df) <- c("collocation", "transcript_freq")

  descript_ngram_df <-data.frame(collocation = descript_ngram_df$collocation,
                                 transcript_freq = descript_ngram_df$transcript_freq)
  for (i in 1:collocate_length){
    descript_ngram_df <- cbind(descript_ngram_df, seq(from=i, to = dim(descript_ngram_df)[1]+(i-1)))
    names(descript_ngram_df)[ncol(descript_ngram_df)]<-paste0("word_",i)
  }

  descript_ngram_df$first_word <- stringr::word(descript_ngram_df$collocation,1)

  #getting collocations from notes
  col_descript <- note_token %>% quanteda.textstats::textstat_collocations(min_count = 1,
                                                                           size=collocate_length)

  col_merged_descript <- dplyr::left_join(descript_ngram_df, col_descript, by = "collocation")

  #replacing na's with 0's
  col_merged_descript$count <- replace(col_merged_descript$count,is.na(col_merged_descript$count),0)

  col_descript_long <- col_merged_descript %>%  tidyr::pivot_longer(cols = 3:(collocate_length+2),
                                                                    names_to = "col_number",
                                                                    names_prefix = "word_",
                                                                    values_to = "word_number"
  )
  #calculating relative frequency based on number of times colloactions occur
  col_descript_long$rel_freq <- col_descript_long$count/col_descript_long$transcript_freq

  descript_tomerge <- col_descript_long %>% dplyr::select(rel_freq, col_number, word_number) %>%
    tidyr::pivot_wider(names_from = col_number, values_from = rel_freq, names_prefix = "col_")

  add_word<-descript_ngram_df %>% dplyr::select(word_1, first_word, collocation) %>%
    dplyr::rename("word_number"="word_1")

  descript_tomerge <- dplyr::left_join(descript_tomerge, add_word, by = "word_number")
  descript_tomerge<-descript_tomerge %>% dplyr::rename("to_merge"="first_word")

  for (i in 2:collocate_length){
    descript_tomerge[dim(descript_tomerge)[1]-(collocate_length-i),]$to_merge <-
      stringr::word(descript_tomerge[dim(descript_tomerge)[1]-(collocate_length-1),]$collocation, i)
  }

  return(descript_tomerge)

}

collocate_comments_fuzzy <- function(transcript_token, note_token, collocate_length=5, n_bands=50, threshold=0.7, n_gram_width=4){
  collocation.y <- dist <- collocation.x <- weighted_count <- col_number <- word_number <-
    word_1 <- first_word <- collocation <- NULL
  `%>%` <- magrittr::`%>%`
  #Same as previous notes
  descript_ngrams <- quanteda::tokens_ngrams(transcript_token, n = collocate_length, skip = 0L, concatenator = " ")
  descript_ngram_df <- data.frame(unlist(descript_ngrams))
  rel_freq <-as.data.frame(table(descript_ngram_df))
  descript_ngram_df <- dplyr::left_join(descript_ngram_df, rel_freq, by = "unlist.descript_ngrams.")
  names(descript_ngram_df) <- c("collocation", "transcript_freq")

  descript_ngram_df <-data.frame(collocation = descript_ngram_df$collocation,
                                 transcript_freq = descript_ngram_df$transcript_freq)
  for (i in 1:collocate_length){
    descript_ngram_df <- cbind(descript_ngram_df, seq(from=i, to = dim(descript_ngram_df)[1]+(i-1)))
    names(descript_ngram_df)[ncol(descript_ngram_df)]<-paste0("word_",i)
  }

  descript_ngram_df$first_word <- stringr::word(descript_ngram_df$collocation,1)

  col_descript <- note_token %>% quanteda.textstats::textstat_collocations(min_count = 1,
                                                                           size=collocate_length)

  col_merged_descript <- dplyr::left_join(descript_ngram_df, col_descript, by = "collocation")
  col_merged_descript$count <- replace(col_merged_descript$count,is.na(col_merged_descript$count),0)

  ###Fuzzy Matching

  # Finding collocations that do not directly match the transcript
  mismatches <- dplyr::anti_join(col_descript, descript_ngram_df, by = "collocation")

  fuzzy_matches <- zoomerjoin::jaccard_right_join(descript_ngram_df, mismatches,
                                                  by='collocation', similarity_column="dist", n_bands=n_bands,
                                                  threshold=threshold, n_gram_width=n_gram_width)%>%
    dplyr::filter(!is.na(collocation.x)) %>%
    dplyr::group_by(collocation.y) %>%
    dplyr::slice_max(order_by=dist, n=1) #finding closest match based on Jaccard Distance
  #counting the number of closest matches per collocation
  if (dim(fuzzy_matches)[1] != 0){
    close_freq<-as.data.frame(table(fuzzy_matches$collocation.y))
    close_freq <- close_freq %>% dplyr::rename("collocation.y"="Var1", "close_freq"="Freq")

    fuzzy_matches <- dplyr::left_join(fuzzy_matches, close_freq, by="collocation.y")

    #Fuzzy matches weight
    fuzzy_matches$weighted_count <- (fuzzy_matches$count*fuzzy_matches$dist)/(fuzzy_matches$close_freq)

    #Counting up the number of fuzzy matches per transcript collocation
    fuzzy_col <-fuzzy_matches %>% dplyr::group_by(collocation.x) %>%
      dplyr::summarise (fuzzy_count = sum(weighted_count))

    fuzzy_col <- fuzzy_col %>% dplyr::rename("collocation"="collocation.x")

    col_merged_fuzzy <- dplyr::left_join(col_merged_descript, fuzzy_col, by = "collocation")
  } else{
    col_merged_fuzzy <- col_merged_descript
    col_merged_fuzzy$fuzzy_count <- NA

  }
  col_merged_fuzzy$fuzzy_count <- replace(col_merged_fuzzy$fuzzy_count, is.na(col_merged_fuzzy$fuzzy_count),0)
  #Counting up fuzzy and non-fuzzy matches
  col_merged_fuzzy$final_count <- col_merged_fuzzy$count+col_merged_fuzzy$fuzzy_count

  col_descript_long <- col_merged_fuzzy %>%  tidyr::pivot_longer(cols = 3:(collocate_length+2),
                                                                 names_to = "col_number",
                                                                 names_prefix = "word_",
                                                                 values_to = "word_number"
  )
  col_descript_long$rel_freq <- col_descript_long$final_count/col_descript_long$transcript_freq

  descript_tomerge <- col_descript_long %>% dplyr::select(rel_freq, col_number, word_number) %>%
    tidyr::pivot_wider(names_from = col_number, values_from = rel_freq, names_prefix = "col_")

  add_word<-descript_ngram_df %>% dplyr::select(word_1, first_word, collocation) %>%
    dplyr::rename("word_number"="word_1")

  descript_tomerge <- dplyr::left_join(descript_tomerge, add_word, by = "word_number")
  descript_tomerge<-descript_tomerge %>% dplyr::rename("to_merge"="first_word")

  for (i in 2:collocate_length){
    descript_tomerge[dim(descript_tomerge)[1]-(collocate_length-i),]$to_merge <-
      stringr::word(descript_tomerge[dim(descript_tomerge)[1]-(collocate_length-1),]$collocation, i)
  }

  return(descript_tomerge)

}

tokenize_source <- function(tbl, source_row, text_column){
  `%>%` <- magrittr::`%>%`

  source <- data.frame(tbl[source_row,])
  colnames(source) <- colnames(tbl)

  description_df <- source[[text_column]]
  description_df <- gsub("<.*?>", " ", description_df) #removing all html expressions
  description_df <- gsub("\\\\n", " ", description_df) #removing line breaks
  description_df <- stringi::stri_trans_general(description_df, "latin-ascii")
  description_df <- gsub("\\$", " ", description_df) #removing dollar sign
  description_df <- gsub("-", " ", description_df) #removing dash with space
  description_df <- gsub(":", "", description_df) #removing colon without space
  description_df <- gsub("([[:alnum:]])(\\.)([[:alnum:]])","\\1\\3", description_df) #removing period between characters
  description_df <- gsub("([[:alnum:]])(,)([[:alnum:]])","\\1\\3", description_df) #removing comma between characters
  description_df <- tolower(description_df)

  corpus_descript <- quanteda::corpus(description_df) #creating a corpus

  toks_des <- quanteda::tokens(corpus_descript, remove_punct = TRUE) #tokenizing transcript
  return(toks_des)
}

tokenize_derivative <- function(tbl, source_row, text_column){

  derivatives <- data.frame(tbl[-source_row,])
  colnames(derivatives) <- colnames(tbl)

  comment_df <- data.frame(docid = cbind(seq(1:nrow(derivatives))),
                           text=tolower(derivatives[[text_column]])) #lowercasing text

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

