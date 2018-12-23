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

(`data_corpus_inaugural` is a sample corpus from `quanteda` of inaugural
speeches of US presidents.) Then use `quanteda` functions to convert to
desired tokenized form:

``` r
tok <- tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
               remove_separators = TRUE)
tok <- tokens_remove (tok, stopwords("english"))
```

## keywords

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

``` r
x <- ttt_fit_topics (dat, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1   | Topic 2 | Topic 3  | Topic 4 | Topic 5 |
| :-------- | :------ | :------- | :------ | :------ |
| govern    | peopl   | can      | nation  | nation  |
| nation    | us      | us       | peopl   | state   |
| power     | may     | law      | govern  | can     |
| everi     | one     | shall    | state   | upon    |
| peac      | great   | american | public  | world   |
| unit      | upon    | everi    | world   | great   |
| america   | must    | power    | shall   | must    |
| constitut | power   | must     | great   | peopl   |
| freedom   | citizen | union    | us      | never   |
| right     | new     | one      | countri | need    |

``` r
x <- ttt_fit_topics (dat, years = 1789:1900, ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1  | Topic 2 | Topic 3 | Topic 4   | Topic 5 |
| :------- | :------ | :------ | :-------- | :------ |
| state    | nation  | govern  | can       | can     |
| us       | govern  | peopl   | peac      | great   |
| nation   | us      | nation  | everi     | may     |
| citizen  | peopl   | citizen | state     | peopl   |
| shall    | may     | free    | us        | must    |
| countri  | upon    | great   | nation    | world   |
| peopl    | america | must    | constitut | law     |
| american | right   | countri | shall     | power   |
| time     | power   | make    | must      | make    |
| world    | time    | unit    | right     | countri |

``` r
x <- ttt_fit_topics (dat, topic = "nation", ntopics = 5)
topicmodels::get_terms(x, 10) %>% knitr::kable()
```

| Topic 1  | Topic 2 | Topic 3 | Topic 4 | Topic 5 |
| :------- | :------ | :------ | :------ | :------ |
| nation   | nation  | nation  | nation  | nation  |
| peopl    | great   | may     | upon    | citizen |
| govern   | one     | peopl   | power   | presid  |
| one      | can     | govern  | right   | us      |
| everi    | part    | everi   | peopl   | law     |
| like     | now     | parti   | govern  | justic  |
| neighbor | power   | state   | peac    | america |
| live     | place   | honor   | us      | govern  |
| believ   | new     | spirit  | shall   | ever    |
| world    | respons | happi   | great   | peopl   |
