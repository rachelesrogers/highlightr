# Collocation of Comments

This function provides the frequency of collocations in comments that
correspond to the provided transcript.

## Usage

``` r
collocate_comments(transcript_token, note_token, collocate_length = 5)
```

## Arguments

- transcript_token:

  transcript token to act as baseline for notes, resulting from
  [`tokenize_source()`](https://rachelesrogers.github.io/highlightr/reference/tokenize_source.md)

- note_token:

  tokenized document of notes, resulting from
  [`tokenize_derivative()`](https://rachelesrogers.github.io/highlightr/reference/tokenize_derivative.md)

- collocate_length:

  the length of the collocation. Default is 5

## Value

data frame of the transcript and corresponding note frequency

## Details

Collocations are sequences of words present in the source document. For
example, the phrase "the blue bird flies" contains one collocation of
length 4 ("the blue bird flies"), two collocations of length 3 ("the
blue bird" and "blue bird flies"), and three collocations of length 2
("the blue", "blue bird", and "bird flies"). This function counts the
number of corresponding phrases in the 'notes', or the derivative
documents. Matches between the two documents must be exact

## Examples

``` r
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example[1:100,], text_column="Notes")
# Tokenize source document
toks_source <- tokenize_source(transcript_example)
# Compute collocation frequencies
collocation_object <- collocate_comments(toks_source, toks_comment)
```
