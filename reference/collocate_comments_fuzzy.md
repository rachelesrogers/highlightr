# Collocate Comments Fuzzy

This function provides the frequency of collocations in comments that
correspond to the provided transcript, using fuzzy matching.

## Usage

``` r
collocate_comments_fuzzy(
  transcript_token,
  note_token,
  collocate_length = 5,
  n_bands = 50,
  threshold = 0.7,
  n_gram_width = 4
)
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

- n_bands:

  number of bands used in MinHash algorithm passed to
  [`zoomerjoin::jaccard_right_join()`](https://beniaminogreen.github.io/zoomerjoin/reference/jaccard-joins.html).
  Default is 50

- threshold:

  Jaccard distance threshold to be considered a match passed to
  [`zoomerjoin::jaccard_right_join()`](https://beniaminogreen.github.io/zoomerjoin/reference/jaccard-joins.html).
  Default is 0.7

- n_gram_width:

  width of n-grams used in Jaccard distance calculation passed to
  [`zoomerjoin::jaccard_right_join()`](https://beniaminogreen.github.io/zoomerjoin/reference/jaccard-joins.html).
  Default is 4

## Value

data frame of the transcript and corresponding note frequency

## Details

Collocations are sequences of words present in the source document. For
example, the phrase "the blue bird flies" contains one collocation of
length 4 ("the blue bird flies"), two collocations of length 3 ("the
blue bird" and "blue bird flies"), and three collocations of length 2
("the blue", "blue bird", and "bird flies"). This function counts the
number of corresponding phrases in the 'notes', or the derivative
documents. Due to fuzzy matching, indirect matches are included with a
weight of (n\*d)/m, where n is the frequency of the fuzzy collocation, d
is the Jaccard similarity between the transcript and note collocation,
and m is the number of closest matches for the note collocation.

## Examples

``` r
# Tokenize the derivative document
toks_comment <- tokenize_derivative(comment_example[1:10,], text_column="Notes")
# Tokenize source document
toks_source <- tokenize_source(transcript_example)
# Compute collocation frequencies using fuzzy (or indirect) matching
fuzzy_object <- collocate_comments_fuzzy(toks_source, toks_comment)
#> Joining with `by = join_by(unlist.descript_ngrams.)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(collocation)`
#> Warning: A pair of records at the threshold (0.7) have only a 95% chance of being compared.
#> Please consider changing `n_bands` and `band_width`.
#> Joining with `by = join_by(collocation.y)`
#> Joining with `by = join_by(collocation)`
#> Joining with `by = join_by(word_number)`
```
