# Map collocation to ggplot object

This assigns colors based on frequency to the words in the transcript.

## Usage

``` r
collocation_plot(
  frequency_doc,
  colors = c("#f251fc", "#f8ff1b"),
  values = "Freq",
  order = "word_num",
  text = "words"
)
```

## Arguments

- frequency_doc:

  document of frequencies (returned from
  [`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md))

- colors:

  list for color specification for the gradient. Default is
  c("#f251fc","#f8ff1b")

- values:

  column name of values to use in gradient calculation. Default is
  "Freq", corresponding to document returned from
  [`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md)

- order:

  column name corresponding to the the word order of the text. Default
  is "word_num", corresponding to the document returned from
  [`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md)

- text:

  column name corresponding to text to map the gradient to. Default is
  "words", corresponding to the document returned from
  [`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md)

## Value

list of plot, plot object, and frequency

## Examples

``` r
# Identify Source Row
src_row <- which(notepad_example$ID=="source")
merged_frequency <- collocation_frequency(notepad_example, src_row, "Text")
# Create a plot object to assign colors based on frequency
freq_plot <- collocation_plot(merged_frequency)
```
