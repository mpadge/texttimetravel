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
head (x, n = 20)
```

    ##       feature       chi2            p n_target n_reference
    ## 1      school 2130.81344 0.000000e+00        3           0
    ## 2     laissez  255.28992 0.000000e+00        1           0
    ## 3       faire  255.28992 0.000000e+00        1           0
    ## 4     outward  255.28992 0.000000e+00        1           0
    ## 5      attest  255.28992 0.000000e+00        1           0
    ## 6     teacher  255.28992 0.000000e+00        1           0
    ## 7        miss  255.28992 0.000000e+00        1           0
    ## 8       julia  255.28992 0.000000e+00        1           0
    ## 9     coleman  255.28992 0.000000e+00        1           0
    ## 10    writers  127.14790 0.000000e+00        1           1
    ## 11   widening  127.14790 0.000000e+00        1           1
    ## 12      inner  127.14790 0.000000e+00        1           1
    ## 13    widened   84.43453 0.000000e+00        1           2
    ## 14   military   64.90490 7.771561e-16        2          32
    ## 15   changing   63.07833 1.998401e-15        1           3
    ## 16 scientific   50.26500 1.343259e-12        1           4
    ## 17     adjust   41.72309 1.051595e-10        1           5
    ## 18   approval   41.72309 1.051595e-10        1           5
    ## 19       laid   31.04644 2.519285e-08        1           7
    ## 20  spiritual   31.04644 2.519285e-08        1           7

``` r
x <- ttt_keyness (tok, "politic*")
head (x, n = 20)
```

    ##        feature       chi2                 p n_target n_reference
    ## 1    political 2633.43470 0.000000000000000      106           0
    ## 2     politics  275.14397 0.000000000000000       12           0
    ## 3      parties   74.19817 0.000000000000000       13          30
    ## 4        petty   37.28733 0.000000001019446        3           1
    ## 5        voice   35.13833 0.000000003070959        7          17
    ## 6       social   30.58931 0.000000031884568        8          26
    ## 7        party   29.52579 0.000000055177584       13          68
    ## 8    inspiring   28.86219 0.000000077715118        3           2
    ## 9    prejudice   27.81476 0.000000133503763        5          10
    ## 10   regaining   27.43489 0.000000162473518        2           0
    ## 11 significant   27.43489 0.000000162473518        2           0
    ## 12       imply   27.43489 0.000000162473518        2           0
    ## 13      stakes   27.43489 0.000000162473518        2           0
    ## 14 politicians   27.43489 0.000000162473518        2           0
    ## 15  industrial   23.53479 0.000001226751184        7          25
    ## 16     members   21.51050 0.000003518957835        7          27
    ## 17     pledged   18.76852 0.000014758321081        4           9
    ## 18    economic   18.07462 0.000021241358268        8          40
    ## 19   religious   17.98225 0.000022297426535        6          23
    ## 20   essential   17.39381 0.000030381302722        7          32

## topics

``` r
x <- ttt_fit_topics (dat, ntopics = 5)
topicmodels::get_terms(x, 20)
```

    ##       Topic 1     Topic 2     Topic 3    Topic 4    Topic 5    
    ##  [1,] "nation"    "state"     "can"      "govern"   "countri"  
    ##  [2,] "peopl"     "nation"    "govern"   "peopl"    "state"    
    ##  [3,] "must"      "great"     "us"       "us"       "govern"   
    ##  [4,] "may"       "can"       "new"      "power"    "time"     
    ##  [5,] "great"     "make"      "must"     "peac"     "constitut"
    ##  [6,] "law"       "upon"      "shall"    "countri"  "american" 
    ##  [7,] "world"     "govern"    "may"      "world"    "power"    
    ##  [8,] "govern"    "power"     "principl" "made"     "may"      
    ##  [9,] "everi"     "citizen"   "world"    "law"      "year"     
    ## [10,] "without"   "now"       "upon"     "nation"   "freedom"  
    ## [11,] "us"        "must"      "freedom"  "american" "public"   
    ## [12,] "shall"     "everi"     "everi"    "citizen"  "right"    
    ## [13,] "men"       "give"      "duti"     "upon"     "best"     
    ## [14,] "duti"      "secur"     "peopl"    "right"    "interest" 
    ## [15,] "public"    "one"       "public"   "america"  "one"      
    ## [16,] "right"     "countri"   "hope"     "everi"    "can"      
    ## [17,] "upon"      "shall"     "citizen"  "new"      "forc"     
    ## [18,] "constitut" "faith"     "live"     "now"      "foreign"  
    ## [19,] "high"      "constitut" "peac"     "preserv"  "civil"    
    ## [20,] "america"   "time"      "let"      "call"     "world"

``` r
x <- ttt_fit_topics (dat, years = 1789:1900, ntopics = 5)
topicmodels::get_terms(x, 20)
```

    ##       Topic 1     Topic 2     Topic 3    Topic 4    Topic 5    
    ##  [1,] "nation"    "state"     "can"      "govern"   "countri"  
    ##  [2,] "peopl"     "nation"    "govern"   "peopl"    "state"    
    ##  [3,] "must"      "great"     "us"       "us"       "govern"   
    ##  [4,] "may"       "can"       "new"      "power"    "time"     
    ##  [5,] "great"     "make"      "must"     "peac"     "constitut"
    ##  [6,] "law"       "upon"      "shall"    "countri"  "american" 
    ##  [7,] "world"     "govern"    "may"      "world"    "power"    
    ##  [8,] "govern"    "power"     "principl" "made"     "may"      
    ##  [9,] "everi"     "citizen"   "world"    "law"      "year"     
    ## [10,] "without"   "now"       "upon"     "nation"   "freedom"  
    ## [11,] "us"        "must"      "freedom"  "american" "public"   
    ## [12,] "shall"     "everi"     "everi"    "citizen"  "right"    
    ## [13,] "men"       "give"      "duti"     "upon"     "best"     
    ## [14,] "duti"      "secur"     "peopl"    "right"    "interest" 
    ## [15,] "public"    "one"       "public"   "america"  "one"      
    ## [16,] "right"     "countri"   "hope"     "everi"    "can"      
    ## [17,] "upon"      "shall"     "citizen"  "new"      "forc"     
    ## [18,] "constitut" "faith"     "live"     "now"      "foreign"  
    ## [19,] "high"      "constitut" "peac"     "preserv"  "civil"    
    ## [20,] "america"   "time"      "let"      "call"     "world"

``` r
x <- ttt_fit_topics (dat, topic = "nation", ntopics = 5)
topicmodels::get_terms(x, 20)
```

    ##       Topic 1    Topic 2   Topic 3    Topic 4   Topic 5    
    ##  [1,] "nation"   "nation"  "nation"   "nation"  "nation"   
    ##  [2,] "great"    "citizen" "may"      "can"     "one"      
    ##  [3,] "world"    "power"   "peopl"    "countri" "law"      
    ##  [4,] "life"     "great"   "respect"  "america" "govern"   
    ##  [5,] "new"      "us"      "everi"    "let"     "peopl"    
    ##  [6,] "neighbor" "peopl"   "honor"    "bless"   "constitut"
    ##  [7,] "right"    "upon"    "state"    "us"      "now"      
    ##  [8,] "peopl"    "govern"  "govern"   "futur"   "parti"    
    ##  [9,] "govern"   "peac"    "determin" "advanc"  "power"    
    ## [10,] "day"      "purpos"  "without"  "great"   "war"      
    ## [11,] "choic"    "presid"  "among"    "upon"    "time"     
    ## [12,] "duti"     "one"     "citizen"  "govern"  "state"    
    ## [13,] "protect"  "everi"   "upon"     "everi"   "part"     
    ## [14,] "believ"   "respons" "exist"    "heart"   "world"    
    ## [15,] "war"      "state"   "happi"    "singl"   "speak"    
    ## [16,] "see"      "prosper" "influenc" "idea"    "full"     
    ## [17,] "man"      "can"     "individu" "one"     "accept"   
    ## [18,] "institut" "futur"   "shall"    "peopl"   "great"    
    ## [19,] "peac"     "common"  "spirit"   "justic"  "strong"   
    ## [20,] "mind"     "foreign" "interest" "right"   "place"
