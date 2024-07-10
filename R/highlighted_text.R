#' Create Highlighted Testimony
#'
#' Adds html tags to create a highlighted testimony corresponding to word frequency.
#'
#' @param plot_object plot object resulting from [collocation_plot()]
#' @param labels lower and upper labels for the gradient scale
#'
#' @return html code for highlighted text
#' @export
#'
#' @examples comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
#' toks_comment <- token_comments(comment_example_rename)
#' transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
#' toks_transcript <- token_transcript(transcript_example_rename)
#' collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)
#' merged_frequency <- transcript_frequency(transcript_example_rename, collocation_object)
#' freq_plot <- collocation_plot(merged_frequency)
#' page_highlight <- highlighted_text(freq_plot, merged_frequency)

highlighted_text <- function(plot_object, labels=c("","")){
  `%>%` <- magrittr::`%>%`
  page_df<-plot_object$build$data[[1]]

  # page_df$stanza_line <- -page_df$y

  page_df$ID <- seq.int(nrow(page_df))

  page_df$cleancolor <- gsub("#","",page_df$colour)

  page_df$nonmissing_val <- !(grepl("<.*?>",page_df$label)) & !(page_df$label %in% "-")

  page_df$rgb <- NA
  page_df$color_def <- NA
  page_df$word_assign <- NA
  first_word <- "Yes"

  #### CSS Color Assign ###
  #Get color from ggplot object, and paste css code together to print colors
  for (i in 1:length(page_df$colour)){
    if (grepl("<.*?>",page_df$label[i])){
      page_df$word_assign[i] <- page_df$label[i]
    }else if (first_word == "Yes"){
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background: linear-gradient(to right,",page_df$colour[i],",",page_df$colour[i],") \">",page_df$label[i],"&nbsp;","</div>", sep="")
      first_word <- "No"
    }else {
      previous_color <- max(which(page_df$nonmissing_val)[which(page_df$nonmissing_val)<i])
      if (page_df$label[i] =="-"){
      next_color <- min(which(page_df$nonmissing_val)[which(page_df$nonmissing_val)>i])
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background-color: ",page_df$colour[previous_color]," \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }else{
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background: linear-gradient(to right,",page_df$colour[previous_color],",",page_df$colour[i],") \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }
    }
  }

  #Creating the gradient legend box
  low_freq<-plot_object$freq[which.min(plot_object$freq$frequency),]
  colnames(low_freq) <- c("label", "frequency", "x")
  low_combined<- dplyr::inner_join(low_freq,plot_object$build$data[[1]], by=c("label","x"))

  high_freq<-plot_object$freq[which.max(plot_object$freq$frequency),]
  colnames(high_freq) <- c("label", "frequency", "x")
  high_combined<- dplyr::inner_join(high_freq,plot_object$build$data[[1]], by=c("label","x"))

  page_gradient <- paste("<div>",labels[1],round(low_combined$frequency[1]),"<div style=\"
    height: 20px;
    width: 200px;
    display: inline-block;
    background: linear-gradient(45deg,",low_combined$colour[1],",", high_combined$colour[1],");\">","</div>",round(high_combined$frequency[1]),labels[2],"</div>")

  complete_wordassign<-paste(as.vector(page_df$word_assign), collapse="")

  paste(page_gradient, complete_wordassign)

}
