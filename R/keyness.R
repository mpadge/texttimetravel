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
#' head (x, n = 20) # first 3 words are political, politics, and parties
#' x <- ttt_keyness (tok, "politic*", remove_keyword = TRUE)
#' head (x, n = 20) # first 3 words are parties, petty, and voice
ttt_keyness <- function (x, word = "school", window = 10,
                         remove_keyword = FALSE)
{
    x <- convert_to_tokens (x)

    x <- keyness_core (x, word, window)
    feature <- NULL # remove no visible binding note
    if (remove_keyword)
        x <- dplyr::filter (x, !grepl (word, feature))
    return (x)
}

#' ttt_keyness2
#'
#' Extract association with a specified word from the results of
#' \link{ttt_keyness}. The first function calculates associations with a
#' specified word; this function reduces those only to associations with a
#' second specified word.
#'
#' @param x Either a single \pkg{quanteda} `keyness` object, as for example
#' returned from \link{ttt_keyness}, or a list of such objects, as for example
#' return from \link{ttt_keyness_annual}.
#' @param word Secondary word for which the association with the keyword used in
#' \link{ttt_keyness} is to be extracted.
#' @return A \pkg{quanteda} `keyness` object filtered to the specified
#' associations only (see Note).
#'
#' @note For single `keyness` objects, this function is merely a very thin
#' wrapped around \pkg{dplyr} `filter`. For annual lists of `keyness` objects
#' returned from \link{ttt_keyness_annual}, each year is filtered to the
#' specified associations only, and the list converted to a single `keyness`
#' `data.frame` with an additional `year` column.
#'
#' @export
#' @examples
#' # prepare a corpus of quanteda tokens:
#' dat <- quanteda::data_corpus_inaugural
#' tok <- quanteda::tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
#'                remove_separators = TRUE)
#' tok <- quanteda::tokens_remove(tok, quanteda::stopwords("english"))
#' # then use that to extract keyword associations:
#' x <- ttt_keyness (tok, "politic*")
#' # and filter to specified association only
#' x <- ttt_keyness2 (x, "petty")
ttt_keyness2 <- function (x, word)
{
    if (methods::is (x, "list"))
    {
        is_keyness <- vapply (x, function (i)
                              methods::is (i, "keyness"),
                              logical (1))
        if (!all (is_keyness))
            stop ("x must be list of quanteda keyness objects ",
                  "returned from ttt_keyness_annual")
    } else if (!methods::is (x, "keyness"))
        stop ("x must be an quanteda keyness object ",
              "returned from ttt_keyness or ttt_keyness_annual.")

    if (methods::is (x, "keyness"))
        res <- dplyr::filter (x, grepl (word, x$feature))
    else
    {
        res <- lapply (seq_along (x), function (i) {
                     ret <- dplyr::filter (x [[i]],
                                           grepl (word, x [[i]]$feature))
                     if (nrow (ret) > 0)
                         ret$year <- names (x) [i]
                     return (ret)   })
        res <- do.call (rbind, res)
    }
    return (res)
}

#' ttt_keyness_annual
#'
#' Keyness metrics for associations with specified key words, evaluated on an
#' annual basis; see
#' \url{https://en.wikipedia.org/wiki/Keyword_(linguistics)}
#'
#' @return A list of \pkg{quanteda} `keyness` objects listing words (`features`)
#' and associated keyness statistics; one list item per year (where able to be
#' calcualted).
#' @inheritParams ttt_keyness
#'
#' @note Only those years for which `x` contains the nominated `word` will
#' return entries, and thus the return length of this function may be less than
#' the number of years in the corpus.
#'
#' @export
#' @examples
#' # prepare a corpus of quanteda tokens:
#' dat <- quanteda::data_corpus_inaugural
#' tok <- quanteda::tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
#'                remove_separators = TRUE)
#' tok <- quanteda::tokens_remove(tok, quanteda::stopwords("english"))
#' # then use that to extract keyword associations:
#' \dontrun{
#' x <- ttt_keyness_annual (tok, "school")
#' x <- ttt_keyness_annual (tok, "school", remove_keyword = TRUE)
#' }
ttt_keyness_annual <- function (x, word = "school", window = 10,
                         remove_keyword = FALSE)
{
    x <- convert_to_tokens (x)

    yearvar <- grep ("year", names (quanteda::docvars (x)), ignore.case = TRUE)
    years <- quanteda::docvars (x) [[yearvar]]
    res <- list ()
    for (y in years)
    {
        xy <- quanteda::tokens_subset (x, years == y)
        temp <- keyness_core (xy, word, window)
        if (!is.null (temp))
        {
            feature <- NULL # remove no visible binding note
            if (remove_keyword)
                temp <- dplyr::filter (temp, !grepl (word, feature))
            res [[length (res) + 1]] <- temp
            names (res) [length (res)] <- y
        }
    }
    return (res)
}

convert_to_tokens <- function (x)
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
    return (x)
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
            quanteda::docnames (z) <- c ("test", "reference")
        res <- quanteda::textstat_keyness (z,
                                           seq_len (quanteda::ndoc (word_dfm)))
        res$n_target_rel <- res$n_target / sum (word_dfm)
        res$n_reference_rel <- res$n_reference / sum (not_word_dfm)
    }
    return (res)
}
