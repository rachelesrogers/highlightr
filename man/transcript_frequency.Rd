% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transcript_frequency.R
\name{transcript_frequency}
\alias{transcript_frequency}
\title{Mapping Collocation Frequency to Transcript Document}
\usage{
transcript_frequency(transcript, collocate_object)
}
\arguments{
\item{transcript}{transcript document}

\item{collocate_object}{collocation object (returned
from \code{\link[=collocate_comments_fuzzy]{collocate_comments_fuzzy()}} or \code{\link[=collocate_comments]{collocate_comments()}})}
}
\value{
a dataframe of the transcript document with collocation values by word
}
\description{
This function connects the collocation frequency calculated in
\code{\link[=collocate_comments_fuzzy]{collocate_comments_fuzzy()}} to the base transcript.
}
\examples{
comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
toks_comment <- token_comments(comment_example_rename)
transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
toks_transcript <- token_transcript(transcript_example_rename)
collocation_object <- collocate_comments(toks_transcript, toks_comment)
merged_frequency <- transcript_frequency(transcript_example_rename, collocation_object)
}
