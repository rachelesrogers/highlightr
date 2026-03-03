# highlightr

This package is designed to map a group of individuals’ notes to the
corresponding parent text, based on the frequency with which phrases
occur in the individual notes. The parent text is highlighted
corresponding to this frequency, in order to create a ‘heatmap’ of
popular phrases found in the note sheets.

This example is taken from the initial description of a crime used in a
study of jury perception of algorithm use and demonstrative evidence.

The first step is to re-assign names in the notepad text to correspond
with the expected format used in
[`tokenize_derivative()`](https://rachelesrogers.github.io/highlightr/reference/tokenize_derivative.md)
and use the function to tokenize the comments.

``` r

# load the library
library(highlightr)

# tokenize comments
toks_comment <- tokenize_derivative(comment_example, text_column = "Notes")
```

The next step is to tokenize the transcript in a similar manner.

``` r

# tokenize source document
toks_transcript <- tokenize_source(transcript_example)
```

After that, a fuzzy collocation is used to match the tokenized notes to
the phrases in the tokenized transcript. This function first determines
the number of times a collocation of length 5 occurs in participant
notes. Fuzzy (or indirect) matches are then added to the frequency count
of the transcript collocation that is the closest match. These fuzzy
matches are weighted based on the edit distance between the transcript
collocation and the indirect phrase: $$\frac{n*d}{m}$$

Here, $n$ is the frequency of the fuzzy collocation, $d$ is the Jaccard
similarity between the fuzzy collocation and the transcript collocation
(ranging from 0 to 1, where 1 indicates identical strings), and $m$ is
the number of closest matches for the fuzzy collocation.

``` r

# use fuzzy collocation on source and derivative tokenized documents

collocation_object <- collocate_comments_fuzzy(toks_transcript, toks_comment)

head(collocation_object)
#> # A tibble: 6 × 8
#>   word_number col_1 col_2 col_3 col_4 col_5 to_merge  collocation               
#>         <int> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <chr>                     
#> 1           1  6.96 NA    NA    NA    NA    in        in this case the defendant
#> 2           2  7     6.96 NA    NA    NA    this      this case the defendant r…
#> 3           3  7.93  7     6.96 NA    NA    case      case the defendant richar…
#> 4           4 10     7.93  7     6.96 NA    the       the defendant richard col…
#> 5           5 10    10     7.93  7     6.96 defendant defendant richard cole ha…
#> 6           6 21    10    10     7.93  7    richard   richard cole has been cha…
```

The output assigns the frequency of each collocation to each word that
occurs in that collocation. For example, the first collocation in the
description is “in this case the defendant”, which occurs with a
frequency of 6.96. This is the only collocation in which the first word
will appear, so this is the only collocation value provided for the
first word. The second word, “this” appears in the next collocation as
well: this case the defendant richard, whose frequency is 7, and so on
for all words in the description. Collocations are weighted by the
number of times they appear in the transcript text.

Next, the
[`transcript_frequency()`](https://rachelesrogers.github.io/highlightr/reference/transcript_frequency.md)
function attaches the collocation counts to the full text of the
transcript. The collocation frequencies are averaged per word.

``` r

# connect collocation frequencies to source document

merged_frequency <- transcript_frequency(transcript_example, collocation_object)
```

The combined document is then fed through ggplot to assign gradient
colors based on frequency, and the minimum and maximum values are
recorded.

``` r

# create `ggplot` object of the transcript

freq_plot <- collocation_plot(merged_frequency)
```

``` r

# add html tags to source document

page_highlight <- highlighted_text(freq_plot)
```

After colors have been assigned, HTML output is created for highlighted
text is created based on frequency, as well as a gradient bar indicating
the high and low values. The left side of each word gradient indicates
the frequency of the previous word’s averaged collocation frequency,
while the right side indicates the current word’s averaged collocation
frequency. This HTML output can be rendered into highlighted text by
specifying `` `r page_highlight` `` in an R Markdown document outside of
a code chunk and knitting to HTML:

0

45

In 

this 

case, 

the 

defendant 

- 

Richard 

Cole 

- 

has 

been 

charged 

with 

willfully 

discharging 

a 

firearm 

in 

a 

place 

of 

business. 

This 

crime 

is 

a 

felony. 

Mr. 

Cole 

has 

pleaded 

not 

guilty 

to 

the 

charge. 

You 

will 

now 

read 

a 

summary 

of 

the 

case. 

This 

summary 

was 

prepared 

by 

an 

objective 

court 

clerk. 

It 

describes 

select 

evidence 

that 

was 

presented 

at 

trial. 

  

Alternatively, the `xml2` package can be used to save the output as an
html file, as shown in the following code:

``` r

# load `xml2` library

library(xml2)

# save html output to desired location

xml2::write_html(xml2::read_html(page_highlight), "filename.html")
```

To exclude fuzzy matches, the
[`collocate_comments()`](https://rachelesrogers.github.io/highlightr/reference/collocate_comments.md)
function can be used. Here, the listed frequencies are all whole
numbers, because they are counts (without weighting).

``` r

# use nonfuzzy collocation on the source and derivative tokenized texts

collocation_object_nonfuzzy <- collocate_comments(toks_transcript, toks_comment)

head(collocation_object_nonfuzzy)
#> # A tibble: 6 × 8
#>   word_number col_1 col_2 col_3 col_4 col_5 to_merge  collocation               
#>         <int> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <chr>                     
#> 1           1     6    NA    NA    NA    NA in        in this case the defendant
#> 2           2     7     6    NA    NA    NA this      this case the defendant r…
#> 3           3     7     7     6    NA    NA case      case the defendant richar…
#> 4           4    10     7     7     6    NA the       the defendant richard col…
#> 5           5    10    10     7     7     6 defendant defendant richard cole ha…
#> 6           6    21    10    10     7     7 richard   richard cole has been cha…
```

In this case, the highlighting pattern resembles that when the fuzzy
matches are included, but the maximum value reached is smaller. Note
also that the colors used in highlighting can be changed in the “colors”
argument of the `collocation_plot` function.

``` r

# connect collocation frequencies to source document

merged_frequency_nonfuzzy <- transcript_frequency(transcript_example, collocation_object_nonfuzzy)

# create a `ggplot` object of the transcript, and change colors of the gradient

freq_plot_nonfuzzy <- collocation_plot(merged_frequency_nonfuzzy, colors=c("#15bf7e", "#fcc7ed"))

# add html tags to source document

page_highlight_nonfuzzy <- highlighted_text(freq_plot_nonfuzzy)
```

0

41

In 

this 

case, 

the 

defendant 

- 

Richard 

Cole 

- 

has 

been 

charged 

with 

willfully 

discharging 

a 

firearm 

in 

a 

place 

of 

business. 

This 

crime 

is 

a 

felony. 

Mr. 

Cole 

has 

pleaded 

not 

guilty 

to 

the 

charge. 

You 

will 

now 

read 

a 

summary 

of 

the 

case. 

This 

summary 

was 

prepared 

by 

an 

objective 

court 

clerk. 

It 

describes 

select 

evidence 

that 

was 

presented 

at 

trial. 

  

Additionally, the length of the collocation can be changed. The default
collocation length (shown above) is 5 words. Below, this collocation
length has been changed to 2 words.

``` r

# use nonfuzzy collocations with a collocation length of 2

collocation_object_2col <- collocate_comments(toks_transcript, toks_comment, collocate_length = 2)

head(collocation_object_2col, n=7)
#> # A tibble: 7 × 5
#>   word_number col_1 col_2 to_merge  collocation      
#>         <int> <dbl> <dbl> <chr>     <chr>            
#> 1           1   6      NA in        in this          
#> 2           2   7       6 this      this case        
#> 3           3   7       7 case      case the         
#> 4           4  10       7 the       the defendant    
#> 5           5  22      10 defendant defendant richard
#> 6           6  89      22 richard   richard cole     
#> 7           7  18.5    89 cole      cole has
```

In these shorter collocations, we can see that the collocation
containing the name “Richard Cole” is popular, with a frequency of 89.

``` r

# connect collocation frequencies to source document

merged_frequency_2col <- transcript_frequency(transcript_example, collocation_object_2col)

# create a `ggplot` object of the transcript

freq_plot_2col <- collocation_plot(merged_frequency_2col)

# add html tags to source document

page_highlight_2col <- highlighted_text(freq_plot_2col)
```

0

72

In 

this 

case, 

the 

defendant 

- 

Richard 

Cole 

- 

has 

been 

charged 

with 

willfully 

discharging 

a 

firearm 

in 

a 

place 

of 

business. 

This 

crime 

is 

a 

felony. 

Mr. 

Cole 

has 

pleaded 

not 

guilty 

to 

the 

charge. 

You 

will 

now 

read 

a 

summary 

of 

the 

case. 

This 

summary 

was 

prepared 

by 

an 

objective 

court 

clerk. 

It 

describes 

select 

evidence 

that 

was 

presented 

at 

trial. 
