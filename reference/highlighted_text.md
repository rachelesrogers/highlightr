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
# Rename relevant column to page_notes in the derivative document
comment_example_rename <- dplyr::rename(comment_example, page_notes=Notes)
# Tokenize the derivative document
toks_comment <- token_comments(comment_example_rename)
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
# Add html tags to create a highlighted version of the source document
page_highlight <- highlighted_text(freq_plot, merged_frequency)
```
