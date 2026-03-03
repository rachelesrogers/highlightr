# Tokenize Source Document

This function tokenizes a source document that is to be used in
[`collocate_comments_fuzzy()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments_fuzzy.md)
or
[`collocate_comments()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments.md)

## Usage

``` r
tokenize_source(transcript_file)
```

## Arguments

- transcript_file:

  data frame of the source document, where the source document text is
  in a column named text.

## Value

a tokenized object

## Examples

``` r
# Tokenize source document
toks_source <- tokenize_source(transcript_example)
```
