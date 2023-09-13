#' Create Highlighted Testimony
#'
#' @param plot_object plot object resulting from collocation_plot
#' @param descript collocation frequency document resulting from transcript_frequency
#'
#' @return css code for highlighted text
#' @export
#'
#' @examples
highlighted_text <- function(plot_object, descript){

  page_df<-plot_object$build$data[[1]]

  page_df$stanza_line <- -page_df$y

  page_df$ID <- seq.int(nrow(page_df))

  page_df$cleancolor <- gsub("#","",page_df$colour)

  page_df$rgb <- NA
  page_df$color_def <- NA
  page_df$word_assign <- NA

  #### CSS Color Assign ###
  #Get color from ggplot object, and paste css code together to print colors
  for (i in 1:length(page_df$colour)){
    page_df$rgb[i] <- paste(as.vector(col2rgb(page_df$colour[i])), collapse = ", ")
    if (page_df$label[i] =="\"Q:"){
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }else if (i==1){
      page_df$word_assign[i] <- paste("<br/>","<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background-color: ",page_df$colour[i], "\">",page_df$label[i],"&nbsp;","</div>", sep="")
    } else if (page_df$label[i] %in% c("Q:","A:","Court:","Defense:","Prosecution:")){
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px \">",page_df$label[i],"&nbsp;","</div>", sep="")
    } else if (page_df$label[i+1] %in% c("Q:","A:","Court:","Defense:","Prosecution:") & page_df$x[i]==1){
      page_df$word_assign[i] <- paste("<br/> <div style=\"display: inline-block; padding:0px;
  margin-left:-5px \">",page_df$label[i],"&nbsp;","</div>", sep="")
    } else if (page_df$label[i-1] %in% c("Q:","A:","Court:","Defense:","Prosecution:")){
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background: linear-gradient(to right,",page_df$colour[i-2],",",page_df$colour[i],") \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }else if (page_df$label[i] =="-"){
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background: linear-gradient(to right,",page_df$colour[i-1],",",page_df$colour[i+1],") \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }else if (page_df$label[i-1] =="-"){
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background: linear-gradient(to right,",page_df$colour[i],",",page_df$colour[i],") \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }else if (page_df$label[i-1] =="\"Q:"){
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background: linear-gradient(to right,",page_df$colour[i],",",page_df$colour[i],") \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }else{
      page_df$word_assign[i] <- paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px; background: linear-gradient(to right,",page_df$colour[i-1],",",page_df$colour[i],") \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }
    if (page_df$y[i] %in% page_df[str_detect(page_df$label, "---"),]$y){
      page_df$word_assign[i] <-  paste("<div style=\"display: inline-block; padding:0px;
  margin-left:-5px \">",page_df$label[i],"&nbsp;","</div>", sep="")
    }
    if (page_df$y[i] != -1 & page_df$x[i] == 1 & (page_df$y[i] %in% page_df[str_detect(page_df$label, "---") ,]$y | page_df$label[i] %in% c("Q:","A:","Court:","Defense:","Prosecution:"))){
      page_df$word_assign[i] <- paste("<br/>", page_df$word_assign[i])
    }
  }

  #Creating the gradient legend box
  low_freq<-plot_object$freq[which.min(plot_object$freq$frequency),]
  colnames(low_freq) <- c("line","label", "frequency", "x","y")
  low_freq$y <- -low_freq$y
  low_combined<- inner_join(low_freq,plot_object$build$data[[1]], by=c("label","x","y"))

  high_freq<-plot_object$freq[which.max(plot_object$freq$frequency),]
  colnames(high_freq) <- c("line","label", "frequency", "x","y")
  high_freq$y <- -high_freq$y
  high_combined<- inner_join(high_freq,plot_object$build$data[[1]], by=c("label","x","y"))

  page_gradient <- paste("<div>",round(low_combined$frequency[1],2),"<div style=\"
    height: 20px;
    width: 200px;
    display: inline-block;
    background: linear-gradient(45deg,",low_combined$colour[1],",", high_combined$colour[1],");\">","</div>",round(high_combined$frequency[1],2),"</div>")

  complete_wordassign<-paste(as.vector(page_df$word_assign), collapse="")

  paste(page_gradient, complete_wordassign)

}
