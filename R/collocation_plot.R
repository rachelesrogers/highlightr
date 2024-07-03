#' Map collocation to ggplot object
#'
#' This assigns colors based on frequency to the words in the transcript.
#'
#' @param frequency_doc document of frequencies (returned from
#' [transcript_frequency()])
#' @param n_scenario number of scenarios for which this transcript appeared. Defualt is 1
#' @param colors list for color specification for the gradient. Default is c("#f251fc","#f8ff1b")
#'
#' @return list of plot, plot object, and frequency
#' @export
#'
#' @examples comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
#' toks_comment <- token_comments(comment_example_rename)
#' transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
#' toks_transcript <- token_transcript(transcript_example_rename)
#' collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)
#' merged_frequency <- transcript_frequency(transcript_example_rename, collocation_object)
#' freq_plot <- collocation_plot(merged_frequency)

collocation_plot <- function(frequency_doc,n_scenario=1, colors=c("#f251fc","#f8ff1b")){
  `%>%` <- magrittr::`%>%`
  x_coord <- words <- frequency <- NULL
  frequency_doc[is.na(frequency_doc$Freq),]$Freq <- 0
  xlimit<-max(frequency_doc$x_coord)+5

  #normalizing by number of scenarios
  frequency_doc$frequency<- frequency_doc$Freq/n_scenario

  #Using ggplot to establish gradient
  p <- ggplot2::ggplot(frequency_doc, ggplot2::aes(x=x_coord, y=1, label=words))+
    ggplot2::geom_text(hjust="left", size=5,
                       ggplot2::aes(alpha=frequency, color=frequency))+
    ggplot2::scale_y_reverse()+
    ggplot2::xlim(c(1, xlimit))+
    ggplot2::theme_bw()+
    ggplot2::theme(axis.title.x = ggplot2::element_blank(), axis.title.y = ggplot2::element_blank(),
          axis.text.x=ggplot2::element_blank(),
          axis.ticks.x=ggplot2::element_blank(),
          axis.text.y=ggplot2::element_blank(),
          axis.ticks.y=ggplot2::element_blank(),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          legend.position="bottom") +
    ggplot2::scale_color_gradient(low=colors[1], high=colors[2])

  p_obj <- ggplot2::ggplot_build(p)

  plot_vars<- list(plot = p, build = p_obj, freq=frequency_doc %>% dplyr::select(words, frequency, x_coord))
  return(plot_vars)
}
