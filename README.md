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
library(texttimetravel)
library (quanteda)
library (topicmodels)
dat <- data_corpus_inaugural # from quanteda
```

Then convert to desired tokenized form:

``` r
tok <- tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
               remove_separators = TRUE)
tok <- tokens_remove (tok, stopwords("english"))
```

## keywords

``` r
x <- ttt_keyness (tok, "school")
head (x, n = 20) %>% knitr::kable()
```

| feature    |       chi2 | p | n\_target | n\_reference |
| :--------- | ---------: | -: | --------: | -----------: |
| school     | 2130.81344 | 0 |         3 |            0 |
| laissez    |  255.28992 | 0 |         1 |            0 |
| faire      |  255.28992 | 0 |         1 |            0 |
| outward    |  255.28992 | 0 |         1 |            0 |
| attest     |  255.28992 | 0 |         1 |            0 |
| teacher    |  255.28992 | 0 |         1 |            0 |
| miss       |  255.28992 | 0 |         1 |            0 |
| julia      |  255.28992 | 0 |         1 |            0 |
| coleman    |  255.28992 | 0 |         1 |            0 |
| writers    |  127.14790 | 0 |         1 |            1 |
| widening   |  127.14790 | 0 |         1 |            1 |
| inner      |  127.14790 | 0 |         1 |            1 |
| widened    |   84.43453 | 0 |         1 |            2 |
| military   |   64.90490 | 0 |         2 |           32 |
| changing   |   63.07833 | 0 |         1 |            3 |
| scientific |   50.26500 | 0 |         1 |            4 |
| adjust     |   41.72309 | 0 |         1 |            5 |
| approval   |   41.72309 | 0 |         1 |            5 |
| laid       |   31.04644 | 0 |         1 |            7 |
| spiritual  |   31.04644 | 0 |         1 |            7 |

``` r
x <- ttt_keyness (tok, "politic*")
head (x, n = 20) %>% knitr::kable()
```

| feature     |       chi2 |         p | n\_target | n\_reference |
| :---------- | ---------: | --------: | --------: | -----------: |
| political   | 2633.43470 | 0.0000000 |       106 |            0 |
| politics    |  275.14397 | 0.0000000 |        12 |            0 |
| parties     |   74.19817 | 0.0000000 |        13 |           30 |
| petty       |   37.28733 | 0.0000000 |         3 |            1 |
| voice       |   35.13833 | 0.0000000 |         7 |           17 |
| social      |   30.58931 | 0.0000000 |         8 |           26 |
| party       |   29.52579 | 0.0000001 |        13 |           68 |
| inspiring   |   28.86219 | 0.0000001 |         3 |            2 |
| prejudice   |   27.81476 | 0.0000001 |         5 |           10 |
| regaining   |   27.43489 | 0.0000002 |         2 |            0 |
| significant |   27.43489 | 0.0000002 |         2 |            0 |
| imply       |   27.43489 | 0.0000002 |         2 |            0 |
| stakes      |   27.43489 | 0.0000002 |         2 |            0 |
| politicians |   27.43489 | 0.0000002 |         2 |            0 |
| industrial  |   23.53479 | 0.0000012 |         7 |           25 |
| members     |   21.51050 | 0.0000035 |         7 |           27 |
| pledged     |   18.76852 | 0.0000148 |         4 |            9 |
| economic    |   18.07462 | 0.0000212 |         8 |           40 |
| religious   |   17.98225 | 0.0000223 |         6 |           23 |
| essential   |   17.39381 | 0.0000304 |         7 |           32 |

## topics

``` r
x <- ttt_fit_topics (dat, ntopics = 5)
topicmodels::get_terms(x, 20) %>% knitr::kable()
```

| Topic 1   | Topic 2  | Topic 3  | Topic 4 | Topic 5  |
| :-------- | :------- | :------- | :------ | :------- |
| us        | peopl    | govern   | can     | nation   |
| nation    | shall    | nation   | govern  | upon     |
| can       | great    | peac     | peac    | must     |
| citizen   | upon     | state    | countri | new      |
| constitut | one      | must     | state   | one      |
| govern    | power    | war      | public  | everi    |
| work      | countri  | peopl    | unit    | citizen  |
| world     | may      | may      | everi   | year     |
| great     | interest | power    | may     | peopl    |
| state     | now      | us       | union   | great    |
| peopl     | world    | good     | must    | right    |
| law       | american | america  | nation  | made     |
| free      | best     | time     | duti    | power    |
| now       | govern   | world    | respect | secur    |
| freedom   | us       | can      | offic   | need     |
| hope      | duti     | congress | time    | state    |
| power     | law      | great    | world   | free     |
| make      | public   | men      | law     | countri  |
| presid    | state    | countri  | right   | human    |
| america   | right    | better   | power   | progress |

``` r
x <- ttt_fit_topics (dat, years = 1789:1900, ntopics = 5)
topicmodels::get_terms(x, 20) %>% knitr::kable()
```

| Topic 1  | Topic 2   | Topic 3   | Topic 4  | Topic 5 |
| :------- | :-------- | :-------- | :------- | :------ |
| peopl    | govern    | everi     | nation   | can     |
| power    | nation    | govern    | state    | nation  |
| govern   | constitut | us        | countri  | countri |
| great    | upon      | world     | peopl    | us      |
| can      | war       | peopl     | law      | free    |
| american | peopl     | state     | interest | upon    |
| new      | right     | new       | us       | peac    |
| time     | peac      | constitut | can      | citizen |
| one      | now       | may       | shall    | time    |
| must     | may       | upon      | great    | may     |
| state    | public    | citizen   | now      | shall   |
| make     | one       | power     | american | govern  |
| law      | liberti   | must      | america  | must    |
| act      | must      | right     | must     | union   |
| unit     | freedom   | secur     | world    | purpos  |
| best     | shall     | shall     | union    | great   |
| us       | interest  | duti      | spirit   | state   |
| peac     | law       | made      | principl | peopl   |
| offic    | state     | let       | may      | power   |
| place    | power     | faith     | congress | duti    |

``` r
x <- ttt_fit_topics (dat, topic = "nation", ntopics = 5)
topicmodels::get_terms(x, 20) %>% knitr::kable()
```

| Topic 1   | Topic 2 | Topic 3  | Topic 4  | Topic 5   |
| :-------- | :------ | :------- | :------- | :-------- |
| nation    | nation  | nation   | nation   | nation    |
| one       | us      | respect  | peopl    | great     |
| peopl     | let     | time     | govern   | right     |
| togeth    | respons | neighbor | upon     | govern    |
| america   | world   | peopl    | everi    | power     |
| govern    | peac    | work     | honor    | place     |
| power     | upon    | made     | state    | citizen   |
| now       | can     | life     | preserv  | world     |
| servic    | power   | great    | may      | peopl     |
| presid    | just    | must     | interest | can       |
| god       | war     | need     | can      | speak     |
| idea      | great   | without  | spirit   | everi     |
| part      | citizen | protect  | duti     | constitut |
| faith     | futur   | like     | free     | within    |
| freedom   | everi   | justic   | determin | protect   |
| constitut | new     | one      | among    | law       |
| everi     | purpos  | man      | love     | like      |
| choic     | peopl   | world    | parti    | limit     |
| offic     | see     | live     | union    | execut    |
| state     | shall   | bodi     | happi    | common    |
