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
  [`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md))

- n_scenario:

  number of scenarios for which this transcript appeared. Defualt is 1

- colors:

  list for color specification for the gradient. Default is
  c("#f251fc","#f8ff1b")

## Value

list of plot, plot object, and frequency

## Examples

``` r
# Tokenize the derivative document
src_row <- which(notepad_example$ID=="source")
toks_comment <- tokenize_derivative(notepad_example, source_row=src_row, text_column="Text")
# Tokenize source document
toks_source <- tokenize_source(notepad_example, source_row=src_row, text_column="Text")
# Merge frequencies with source document to provide averages by word and correct formatting
merged_frequency <- collocation_frequency(notepad_example[src_row,][["Text"]],
toks_source, toks_comment)
# Create a plot object to assign colors based on frequency
freq_plot <- collocation_plot(merged_frequency)
```
