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
comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example_rename)
# Rename relevant column in the source document to text
transcript_example_rename <- dplyr::rename(transcript_example, text=Text)
# Tokenize source document
toks_source <- tokenize_source(transcript_example_rename)
# Compute collocation frequencies
collocation_object <- collocate_comments(toks_source, toks_comment)
#> Joining with `by = join_by(tolower.unlist.descript_ngrams..)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(word_number)`
# Merge frequencies with source document to provide averages by word and correct formatting
merged_frequency <- transcript_frequency(transcript_example_rename, collocation_object)
#> Joining with `by = join_by(to_merge)`
#> Joining with `by = join_by(text, lines, n_words, words, word_num, word_length,
#> x_coord, to_merge, stanza_freq, word_number)`
# Create a plot object to assign colors based on frequency
freq_plot <- collocation_plot(merged_frequency)
```
