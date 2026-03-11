# Tokenize comments

This function tokenizes comments that are to be used in
[`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md)

## Usage

``` r
tokenize_derivative(tbl, source_row, text_column)
```

## Arguments

- tbl:

  data frame containing documents, where each row represents a document

- source_row:

  row containing text to be treated as source

- text_column:

  string indicating the name of the column containing derivative text

## Value

tokenized comments

## Examples

``` r
# Tokenize the derivative document
src_row <- which(notepad_example$ID=="source")
toks_comment <- tokenize_derivative(notepad_example, source_row=src_row, text_column="Text")
```
