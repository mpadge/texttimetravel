#' plot.keyness_annual
#' 
#' @param x A 'keyness_annual' object
#' @param ... Ingored here
#' @return Nothing (generates plot)
#' @export
plot.keyness_annual <- function (x, ...)
{
    res <- feature <- chi2 <- year <- NULL # supress no visible binding notes
    if (is.data.frame (x))
    {
        res <- dplyr::select (x, c (feature, chi2, year)) %>%
            dplyr::mutate (year = as.numeric (year)) %>%
            ggplot2::ggplot (ggplot2::aes (x = year,
                                                  y = chi2,
                                                  colour = feature))
        if (nrow (x) < 20) {
            res <- res + ggplot2::geom_line () +
                ggplot2::geom_point (size = 2)
        } else {
            res <- res + ggplot2::geom_smooth (method = loess) +
                ggplot2::geom_point (size = 2)
        }
        print (res)
    }
    invisible (res)
}
