# Map collocation to ggplot object

This assigns colors based on frequency to the words in the transcript.

## Usage

``` r
collocation_plot(
  frequency_doc,
  n_scenario = 1,
  colors = c("#f251fc", "#f8ff1b")
)
```

## Arguments

- frequency_doc:

  document of frequencies (returned from
  [`transcript_frequency()`](https://rachelesrogers.github.io/highlightr/reference/transcript_frequency.md))

- n_scenario:

  number of scenarios for which this transcript appeared. Defualt is 1

- colors:

  list for color specification for the gradient. Default is
  c("#f251fc","#f8ff1b")

## Value

list of plot, plot object, and frequency

## Examples

``` r
# Rename relevant column to page_notes in the derivative document
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example, text_column = "Notes")
# Tokenize source document
toks_source <- tokenize_source(transcript_example)
# Compute collocation frequencies
collocation_object <- collocate_comments(toks_source, toks_comment)
# Merge frequencies with source document to provide averages by word and correct formatting
merged_frequency <- transcript_frequency(transcript_example, collocation_object)
# Create a plot object to assign colors based on frequency
freq_plot <- collocation_plot(merged_frequency)
```
