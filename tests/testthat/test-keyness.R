context("keyness")

test_all <- (identical (Sys.getenv ("MPADGE_LOCAL"), "true") |
             identical (Sys.getenv ("TRAVIS"), "true"))

dat <- quanteda::data_corpus_inaugural
tok <- quanteda::tokens (dat, remove_numbers = TRUE, remove_punct = TRUE,
               remove_separators = TRUE)
tok <- quanteda::tokens_remove(tok, quanteda::stopwords("english"))
tok <- tok [docvars (tok)$Year < 1850, ]

test_that("keyness", {
              x <- ttt_keyness (tok, "politic*")
              expect_is (x, "keyness")
              expect_true (length (grep ("politic*", x$feature)) > 1)
              expect_equal (ncol (x), 7)
              x <- ttt_keyness (tok, "politic*", remove_keyword = TRUE)
              expect_is (x, "keyness")
              expect_true (length (grep ("politic*", x$feature)) == 0)
})

test_that("keyness_annual", {
              x <- ttt_keyness_annual (tok, "politic*")
              expect_is (x, "list")
              expect_true (all (vapply (x, function (i)
                                        methods::is (i, "keyness"),
                                        logical (1))))
              gp <- vapply (x, function (i)
                            length (grep ("politic*", i$feature)),
                            numeric (1))
              expect_true (all (gp > 0))

              x <- ttt_keyness_annual (tok, "politic*", remove_keyword = TRUE)
              expect_is (x, "list")
              expect_true (all (vapply (x, function (i)
                                        methods::is (i, "keyness"),
                                        logical (1))))
              gp <- vapply (x, function (i)
                            length (grep ("politic*", i$feature)),
                            numeric (1))
              expect_true (all (gp == 0))
})

test_that("keyness2", {
              x <- ttt_keyness (tok, "politic*")
              y <- ttt_keyness2 (x, "^party|parties")
              expect_is (y, "keyness")
              expect_equal (nrow (y), 2)
              expect_equal (sort (y$feature), c ("parties", "party"))

              x <- ttt_keyness_annual (tok, "politic*")
              y <- ttt_keyness2 (x, "^party|parties")
              expect_is (y, "keyness")
              expect_true (nrow (y) > 2)
              expect_equal (sort (unique (y$feature)), c ("parties", "party"))
})
