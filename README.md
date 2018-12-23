[![Build
Status](https://travis-ci.org/mpadge/texttimetravel.svg?branch=master)](https://travis-ci.org/mpadge/texttimetravel)
[![Project Status:
Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# texttimetravel

Tools for analysing temporally structured text collections

## Installation

``` r
devtools::install_github ('mpadge/texttimetravel')
```

-----

## Usage

Load packages and a temporally-structured corpus to work with:

``` r
library (texttimetravel)
library (quanteda)
dat <- data_corpus_inaugural
#dat <- corpus_reshape (dat, to = "sentences") # if desired
```

([`data_corpus_inaugural`](https://quanteda.io/reference/data_corpus_inaugural.html)
is a sample corpus from [`quanteda`](https://quanteda.io) of inaugural
speeches of US presidents.) Then use [`quanteda`](https://quanteda.io)
functions to convert to desired tokenized form:

``` r
tok <- tokens (dat,
               remove_numbers = TRUE,
               remove_punct = TRUE,
               remove_separators = TRUE)
tok <- tokens_remove (tok, stopwords("english"))
```

## keywords

Keyword associations can be extracted with the `ttt_keyness` function,
which relies on the `quanteda::keyness` function, yet simplifies the
interface by allowing keyness statistics to be extracted with a single
function call.

``` r
x <- ttt_keyness (tok, "politic*")
head (x, n = 10) %>% knitr::kable()
```

| feature   |       chi2 |         p | n\_target | n\_reference |
| :-------- | ---------: | --------: | --------: | -----------: |
| political | 2633.43470 | 0.0000000 |       106 |            0 |
| politics  |  275.14397 | 0.0000000 |        12 |            0 |
| parties   |   74.19817 | 0.0000000 |        13 |           30 |
| petty     |   37.28733 | 0.0000000 |         3 |            1 |
| voice     |   35.13833 | 0.0000000 |         7 |           17 |
| social    |   30.58931 | 0.0000000 |         8 |           26 |
| party     |   29.52579 | 0.0000001 |        13 |           68 |
| inspiring |   28.86219 | 0.0000001 |         3 |            2 |
| prejudice |   27.81476 | 0.0000001 |         5 |           10 |
| regaining |   27.43489 | 0.0000002 |         2 |            0 |

``` r
x <- ttt_keyness (tok, "school")
head (x, n = 10) %>% knitr::kable()
```

| feature    |           chi2 |     p |   n\_target |                              n\_reference |
| :--------- | -------------: | ----: | ----------: | ----------------------------------------: |
| school     |      2130.8134 |     0 |           3 |                                         0 |
| laissez    |       255.2899 |     0 |           1 |                                         0 |
| faire      |       255.2899 |     0 |           1 |                                         0 |
| outward    |       255.2899 |     0 |           1 |                                         0 |
| attest     |       255.2899 |     0 |           1 |                                         0 |
| teacher    |       255.2899 |     0 |           1 |                                         0 |
| miss       |       255.2899 |     0 |           1 |                                         0 |
| julia      |       255.2899 |     0 |           1 |                                         0 |
| coleman    |       255.2899 |     0 |           1 |                                         0 |
| writers    |       127.1479 |     0 |           1 |                                         1 |
| Note that  |   all words as | socia | ted with "s | chool" occur only once in the corpus, and |
| so even th | ough \(p = 0\) |  in a | ll cases, t |  hese associations can not be interpreted |
| as statist |   ically meani | ngful |           . |                                           |

## topics

The `timetextravel` function `ttt_fit_topics` provides a convenient
wrapper around the functions provided by the
[`topicmodels`](https://cran.r-project.org/package=topicmodels) package,
and provides additional functionality via two additional parameters: 1.
`years`, allowing topic models to be fitted only to those portions of a
corpus corresponding to the specified years; 2. `topic`, allowing models
to be fitted to a specified topic phrase.

``` r
x <- ttt_fit_topics (tok, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1  | Topic 2 | Topic 3   | Topic 4 | Topic 5 |
| :------- | :------ | :-------- | :------ | :------ |
| us       | peopl   | govern    | govern  | nation  |
| nation   | govern  | state     | state   | world   |
| world    | nation  | constitut | nation  | peopl   |
| america  | law     | peopl     | countri | freedom |
| new      | upon    | power     | great   | must    |
| peopl    | can     | can       | public  | us      |
| can      | must    | upon      | power   | can     |
| american | state   | may       | peopl   | shall   |
| must     | countri | nation    | may     | upon    |
| govern   | secur   | countri   | shall   | peac    |

``` r
x <- ttt_fit_topics (tok, years = 1789:1900, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1 | Topic 2   | Topic 3   | Topic 4 | Topic 5   |
| :------ | :-------- | :-------- | :------ | :-------- |
| govern  | power     | state     | peopl   | nation    |
| nation  | govern    | govern    | upon    | state     |
| great   | constitut | constitut | govern  | govern    |
| state   | state     | union     | law     | peopl     |
| power   | peopl     | can       | state   | constitut |
| war     | may       | shall     | shall   | countri   |
| union   | upon      | may       | nation  | may       |
| countri | execut    | power     | countri | can       |
| may     | citizen   | peopl     | public  | great     |
| us      | can       | right     | great   | unit      |

``` r
x <- ttt_fit_topics (tok, topic = "nation", ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1 | Topic 2 | Topic 3  | Topic 4  | Topic 5   |
| :------ | :------ | :------- | :------- | :-------- |
| nation  | nation  | us       | govern   | govern    |
| world   | govern  | nation   | law      | peopl     |
| peopl   | state   | world    | upon     | power     |
| govern  | peopl   | america  | state    | state     |
| can     | countri | peopl    | peopl    | constitut |
| must    | power   | new      | great    | upon      |
| us      | may     | can      | countri  | may       |
| peac    | everi   | american | congress | shall     |
| great   | public  | must     | nation   | citizen   |
| upon    | great   | time     | must     | right     |
