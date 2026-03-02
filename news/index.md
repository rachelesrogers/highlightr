# Changelog

## highlightr (development version)

- Updating transcript_frequency() to appropriately recognize “+”,“=”,
  “.extension”

## highlightr 1.2.0

CRAN release: 2025-10-19

- Providing instructions on how to save highlighted output to .html file

- Correcting `wiki_pages` description with correct number of rows

- Listing packages necessary for creating `wiki_pages` object

- Adding option to specify n-gram width in `collocate_comments_fuzzy`

- Adding comments to example scripts and further description for
  collocation functions

## highlightr 1.1.2

CRAN release: 2025-06-26

- Remove dependency on `fuzzyjoin` package, and use `zoomerjoin` package
  instead

- Change Levenshtein distance calculation in fuzzy joins to Jaccard
  distance

- Re-compute fuzzy weights based on new distance calculation

## highlightr 1.0.2

CRAN release: 2024-10-17

- Clarified wording in vignettes

- Fixed computation issue in collocations not of length 5

- Fixed merge issue with special characters

- Replaced non-ascii characters in datasets

## highlightr 1.0.0

CRAN release: 2024-07-31

- Initial CRAN submission.
