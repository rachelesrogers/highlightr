# Create Highlighted Testimony

Adds html tags to create a highlighted testimony corresponding to word
frequency. To render correctly, the object produced from
`highlighted_text()` can be added outside of a code chunk in an .Rmd
document in the `` `r highlighted_text()` `` format. Alternatively, the
html output can be saved by using the `xml2` package as follows:
`xml2::write_html(xml2::read_html(highlighted_text(), "filepath.html"))`

## Usage

``` r
highlighted_text(plot_object, labels = c("", ""))
```

## Arguments

- plot_object:

  plot object resulting from
  [`collocation_plot()`](https://rachelesrogers.github.io/highlightr/reference/collocation_plot.md)

- labels:

  lower and upper labels for the gradient scale

## Value

html code for highlighted text

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
# Add html tags to create a highlighted version of the source document
page_highlight <- highlighted_text(freq_plot, merged_frequency)
```
