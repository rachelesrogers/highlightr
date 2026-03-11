# highlightr

This package is designed to map a group of derivative texts to the
corresponding parent text, based on the frequency with which phrases
occur in the derivative texts. The parent text is highlighted
corresponding to this frequency, in order to create a ‘heatmap’ of
popular phrases found in the derivative texts.

This example is taken from the initial description of a crime used in a
study of jury perception of algorithm use and demonstrative evidence.
The `notepad_example` data frame contains an ‘ID’ number corresponding
to a study participant, as well as their notes, labelled as ‘Text’. The
first six observations are shown below.

``` r

# load the library
library(highlightr)
library(knitr)

# View first 6 observations
knitr::kable(head(notepad_example))
```

| ID  | Text                                                                                                                                               |
|:----|:---------------------------------------------------------------------------------------------------------------------------------------------------|
| 121 | Richard Cole - charged with discharging firearm in business. // felony . NOT GUILTY.                                                               |
| 197 | Richard Cole - Def: Willfully discarge firearm in biz - Felony. Pleaded NG                                                                         |
| 168 | willfully discharging firearm in a business - felony. not guilty                                                                                   |
| 131 | discharged firearm in business, intentionally                                                                                                      |
| 77  | In this case, the defendant - Richard Cole - has been charged with willfully discharging a firearm in a place of business. This crime is a felony. |
| 24  | defendant - Richard Cole discharging a firearm in a place of business. pleaded not guilty.                                                         |

Additionally, the source document (or study transcript) is included in
`notepad_example` with an ID of ‘source’. The original transcript is
shown here:

``` r

study_transcript <- notepad_example[notepad_example$ID == "source",]$Text

knitr::kable(study_transcript)
```

| x                                                                                                                                                                                                                                                                                                                                                           |
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| In this case, the defendant - Richard Cole - has been charged with willfully discharging a firearm in a place of business. This crime is a felony. Mr. Cole has pleaded not guilty to the charge. You will now read a summary of the case. This summary was prepared by an objective court clerk. It describes select evidence that was presented at trial. |

  
Fuzzy collocation is used to match the tokenized derivative texts to the
phrases in the tokenized source text. This function first determines the
number of times a collocation of length 5 occurs in derivative texts, or
participant notes on the case. Fuzzy (or indirect) matches are then
added to the frequency count of the source collocation that is the
closest match. These fuzzy matches are weighted based on the edit
distance between the source collocation and the indirect phrase:
$$\frac{n*d}{m}$$

Here, $n$ is the frequency of the fuzzy collocation, $d$ is the Jaccard
similarity between the fuzzy collocation and the source collocation
(ranging from 0 to 1, where 1 indicates identical strings), and $m$ is
the number of closest matches for the fuzzy collocation.

The
[`collocation_frequency()`](https://rachelesrogers.github.io/highlightr/reference/collocation_frequency.md)
function attaches the collocation counts to the full text of the
transcript. The collocation frequencies are averaged per word.

``` r

# connect collocation frequencies to source document

merged_frequency <- collocation_frequency(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text", fuzzy=TRUE)
#> Warning in join_func(a = a, b = b, by_a = by_a, by_b = by_b, block_by_a = block_by_a, : A pair of records at the threshold (0.7) have only a 95% chance of being compared.
#> Please consider changing `n_bands` and `band_width`.
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

In this case, the highlighting pattern resembles that when the fuzzy
matches are included, but the maximum value reached is smaller. Note
also that the colors used in highlighting can be changed in the “colors”
argument of the `collocation_plot` function.

``` r

# connect collocation frequencies to source document

merged_frequency_nonfuzzy <- collocation_frequency(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text")

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

In these shorter collocations, we can see that the collocation
containing the name “Richard Cole” is popular, with a frequency of 89.

``` r

# connect collocation frequencies to source document

merged_frequency_2col <- collocation_frequency(notepad_example, source_row=which(notepad_example$ID=="source"), text_column = "Text", collocate_length = 2)

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
