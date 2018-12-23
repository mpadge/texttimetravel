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

| feature   |       chi2 |         p | n\_target | n\_reference | target\_total | reference\_total |
| :-------- | ---------: | --------: | --------: | -----------: | ------------: | ---------------: |
| political | 2633.43470 | 0.0000000 |       106 |            0 |          2477 |            62044 |
| politics  |  275.14397 | 0.0000000 |        12 |            0 |          2477 |            62044 |
| parties   |   74.19817 | 0.0000000 |        13 |           30 |          2477 |            62044 |
| petty     |   37.28733 | 0.0000000 |         3 |            1 |          2477 |            62044 |
| voice     |   35.13833 | 0.0000000 |         7 |           17 |          2477 |            62044 |
| social    |   30.58931 | 0.0000000 |         8 |           26 |          2477 |            62044 |
| party     |   29.52579 | 0.0000001 |        13 |           68 |          2477 |            62044 |
| inspiring |   28.86219 | 0.0000001 |         3 |            2 |          2477 |            62044 |
| prejudice |   27.81476 | 0.0000001 |         5 |           10 |          2477 |            62044 |
| regaining |   27.43489 | 0.0000002 |         2 |            0 |          2477 |            62044 |

``` r
x <- ttt_keyness (tok, "school*")
head (x, n = 10) %>% knitr::kable()
```

| feature      |       chi2 | p | n\_target | n\_reference | target\_total | reference\_total |
| :----------- | ---------: | -: | --------: | -----------: | ------------: | ---------------: |
| schools      | 2255.42401 | 0 |        18 |            0 |           483 |            64038 |
| colleges     |  275.39646 | 0 |         3 |            0 |           483 |            64038 |
| school       |  275.39646 | 0 |         3 |            0 |           483 |            64038 |
| universities |  148.41238 | 0 |         2 |            0 |           483 |            64038 |
| businesses   |   97.94810 | 0 |         2 |            1 |           483 |            64038 |
| harness      |   72.71971 | 0 |         2 |            2 |           483 |            64038 |
| ownership    |   57.58567 | 0 |         2 |            3 |           483 |            64038 |
| free         |   48.75158 | 0 |        10 |          173 |           483 |            64038 |
| watching     |   40.29606 | 0 |         2 |            5 |           483 |            64038 |
| health       |   37.18447 | 0 |         3 |           17 |           483 |            64038 |

Note that all words associated with “school” occur only once in the
corpus, and so even though `p = 0` in all cases, these associations can
not be interpreted as statistically meaningful.

## topics

The function `ttt_fit_topics` provides a convenient wrapper around the
functions provided by the
[`topicmodels`](https://cran.r-project.org/package=topicmodels) package,
and provides additional functionality via two additional parameters:

1.  `years`, allowing topic models to be fitted only to those portions
    of a corpus corresponding to the specified years;
2.  `topic`, allowing models to be fitted around a specified topic
    phrase.

<!-- end list -->

``` r
x <- ttt_fit_topics (tok, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1   | Topic 2 | Topic 3   | Topic 4 | Topic 5  |
| :-------- | :------ | :-------- | :------ | :------- |
| peopl     | nation  | govern    | nation  | us       |
| govern    | peopl   | state     | can     | nation   |
| law       | world   | power     | govern  | america  |
| upon      | must    | peopl     | upon    | world    |
| state     | can     | constitut | countri | new      |
| nation    | peac    | nation    | peopl   | peopl    |
| shall     | us      | may       | law     | can      |
| constitut | govern  | countri   | peac    | american |
| can       | freedom | union     | must    | must     |
| may       | shall   | great     | us      | time     |

``` r
x <- ttt_fit_topics (tok, years = 1789:1900, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1   | Topic 2 | Topic 3   | Topic 4   | Topic 5   |
| :-------- | :------ | :-------- | :-------- | :-------- |
| govern    | state   | peopl     | power     | govern    |
| peopl     | war     | nation    | govern    | state     |
| upon      | nation  | public    | peopl     | power     |
| state     | great   | govern    | constitut | union     |
| constitut | govern  | state     | upon      | constitut |
| law       | everi   | shall     | state     | nation    |
| can       | power   | may       | may       | upon      |
| nation    | peopl   | law       | can       | may       |
| great     | unit    | constitut | countri   | right     |
| shall     | countri | interest  | one       | shall     |

``` r
x <- ttt_fit_topics (tok, topic = "nation", ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1 | Topic 2  | Topic 3 | Topic 4 | Topic 5   |
| :------ | :------- | :------ | :------ | :-------- |
| nation  | us       | state   | govern  | govern    |
| peopl   | nation   | nation  | peopl   | power     |
| world   | world    | govern  | upon    | state     |
| can     | america  | great   | law     | peopl     |
| peac    | must     | countri | nation  | constitut |
| must    | can      | war     | shall   | upon      |
| great   | new      | may     | state   | nation    |
| freedom | peopl    | unit    | must    | countri   |
| us      | american | power   | can     | may       |
| new     | let      | public  | may     | can       |
