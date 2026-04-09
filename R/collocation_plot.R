#' Map collocation to ggplot object
#'
#' This assigns colors based on frequency to the words in the transcript.
#'
#' @param frequency_doc document of frequencies (returned from
#' [collocation_frequency()])
#' @param colors list for color specification for the gradient. Default is c("#f251fc","#f8ff1b")
#' @param values column name of values to use in gradient calculation. Default is "Freq",
#' corresponding to document returned from [collocation_frequency()]
#' @param text column name corresponding to text to map the gradient to. Default is "words",
#' corresponding to the document returned from [collocation_frequency()]
#' @param order column name corresponding to the the word order of the text. Default
#' is "word_num", corresponding to the document returned from [collocation_frequency()]
#'
#' @return list of plot, plot object, and frequency
#' @export
#'
#' @examples
#' # Identify Source Row
#' src_row <- which(notepad_example$ID=="source")
#' merged_frequency <- collocation_frequency(notepad_example, src_row, "Text")
#' # Create a plot object to assign colors based on frequency
#' freq_plot <- collocation_plot(merged_frequency)

collocation_plot <- function(frequency_doc, colors=c("#f251fc","#f8ff1b"), values="Freq",
                             order="word_num", text="words"){
  `%>%` <- magrittr::`%>%`
   x_coord <- words <- frequency <- .data <- NULL
   if (sum(is.na(frequency_doc[[values]])) >0){
  frequency_doc[is.na(frequency_doc[[values]]),][[values]] <- 0}
  xlimit<-max(frequency_doc[[order]])+5

  frequency_doc$frequency<- frequency_doc[[values]]
  frequency_doc$words <- frequency_doc[[text]]
  frequency_doc$x_coord <- frequency_doc[[order]]

  #Using ggplot to establish gradient
  p <- ggplot2::ggplot(frequency_doc, ggplot2::aes(x=.data[[order]], y=1, label=.data[[text]]))+
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
