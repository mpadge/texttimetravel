#' plot.keyness_annual
#' 
#' @param x A 'keyness_annual' object
#' @param ... Ingored here
#' @return Nothing (generates plot)
#' @export
plot.keyness_annual <- function (x, ...)
{
    feature <- chi2 <- year <- NULL # supress no visible binding notes
    if (is.data.frame (x))
    {
        dplyr::select (x, c (feature, chi2, year)) %>%
            dplyr::mutate (year = as.numeric (year)) %>%
            ggplot2::ggplot (ggplot2::aes (x = year,
                                           y = chi2,
                                           colour = feature)) +
            #ggplot2::geom_line () +
            ggplot2::geom_smooth (method = loess)
    }
}
