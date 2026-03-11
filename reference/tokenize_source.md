# Tokenize Source Document

This function tokenizes a source document that is to be used in
[`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md)

## Usage

``` r
tokenize_source(tbl, source_row, text_column)
```

## Arguments

- tbl:

  data frame containing documents, where each row represents a document

- source_row:

  row containing text to be treated as source

- text_column:

  string indicating the name of the column containing derivative text

## Value

a tokenized object

## Examples

``` r
# Tokenize source document
src_row <- which(notepad_example$ID=="source")
toks_source <- tokenize_source(notepad_example, source_row=src_row, text_column = "Text")
```
