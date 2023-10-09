#' Map collocation to ggplot object
#'
#' @param frequency_doc document of frequencies (returned from transcript_frequency)
#' @param n_scenario number of scenarios for which this transcript appeared
#'
#' @return list of plot, plot object, and frequency
#' @export
#'
#' @examples
collocation_plot <- function(frequency_doc,n_scenario=1){
  `%>%` <- magrittr::`%>%`
  frequency_doc[is.na(frequency_doc$Freq),]$Freq <- 0
  xlimit<-max(frequency_doc$x_coord)+5

  #normalizing by number of scenarios
  frequency_doc$frequency<- frequency_doc$Freq/n_scenario

  #Using ggplot to establish gradient
  p <- ggplot2::ggplot(frequency_doc, aes(x=x_coord, y=1, label=words))+
    ggplot2::geom_text(hjust="left", size=5, aes(alpha=frequency, color=frequency))+
    ggplot2::scale_y_reverse()+
    ggplot2::xlim(c(1, xlimit))+
    ggplot2::theme_bw()+
    ggplot2::theme(axis.title.x = element_blank(), axis.title.y = element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.position="bottom") +
    ggplot2::scale_color_gradient(low="#f8ff1b", high="#f251fc")

  p_obj <- ggplot2::ggplot_build(p)

  plot_vars<- list(plot = p, build = p_obj, freq=frequency_doc %>% dplyr::select(words, frequency, x_coord))
  return(plot_vars)
}
