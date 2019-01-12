#' ttt_keyness
#'
#' Keyness metrics for associations with specified key words; see
#' \url{https://en.wikipedia.org/wiki/Keyword_(linguistics)}
#'
#' @param x A \pkg{quanteda} `tokens` list, obtained by `tokens(corpus)`.
#' @param word The key word for which associations with other words are to be
#' calculated.
#' @param window Passed to \pkg{quanteda} `tokens_keep/remove` functions; the
#' number of words surrounding each instance of `word` to be considered in
#' measures of assocation.
#' @param remove_keyword If `TRUE`, remove the specified keyword from results,
#' leaving only associations with that word not the word itself.
#' @param annual Calculate `keyness` statistics on annual bases, rather than for
#' entire corpus at once.
#' @return A \pkg{quanteda} `keyness` object listing words (`features`) and
#' associated keyness statistics.
#' @export
#' @examples
#' # prepare a corpus of quanteda tokens:
#' dat <- quanteda::data_corpus_inaugural
#' tok <- quanteda::tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
#'                remove_separators = TRUE)
#' tok <- quanteda::tokens_remove(tok, quanteda::stopwords("english"))
#' # then use that to extract keyword associations:
#' x <- ttt_keyness (tok, "school")
#' head (x, n = 20)
#' x <- ttt_keyness (tok, "politic*")
#' head (x, n = 20)
ttt_keyness <- function (x, word = "school", window = 10,
                         remove_keyword = FALSE, annual = FALSE)
{
    if (!methods::is (x, "tokens"))
    {
        if (methods::is (x, "corpus"))
        {
            message ("argument is a corpus; translating to tokens")
            x <- quanteda::tokens (x)
        } else
            stop ("unknown class of object; ",
                  "please submit a corpus or tokens object")
    }

    res <- NULL
    if (!annual)
        res <- keyness_core (x, word, window)
    else {
        yearvar <- grep ("year", names (docvars (x)), ignore.case = TRUE)
        years <- docvars (x) [[yearvar]]
        res <- list ()
        for (y in years)
        {
            xy <- quanteda::tokens_subset (x, years == y)
            temp <- keyness_core (xy, word, window)
            if (!is.null (temp))
            {
                res [[length (res) + 1]] <- temp
                names (res) [length (res)] <- y
            }
        }
    }
    return (res)
}

keyness_core <- function (x, word, window)
{
    word_dfm <- quanteda::tokens_keep (x, quanteda::phrase (word),
                                       window = window) %>%
        quanteda::dfm ()
    not_word_dfm <- quanteda::tokens_remove (x, quanteda::phrase (word),
                                             window = window) %>%
        quanteda::dfm ()

    res <- NULL
    if (ncol (word_dfm) > 0 & ncol (not_word_dfm) > 0)
    {
        # wordaround before current PR to quanteda is accepted:
        z <- rbind (word_dfm, not_word_dfm)
        if (quanteda::ndoc (z) == 2)
            docnames (z) <- c ("test", "reference")
        res <- quanteda::textstat_keyness (z,
                                           seq_len (quanteda::ndoc (word_dfm)))
        res$n_target_rel <- res$n_target / sum (word_dfm)
        res$n_reference_rel <- res$n_reference / sum (not_word_dfm)
    }
    return (res)
}
