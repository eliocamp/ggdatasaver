#' Set the data directory
#'
#' Set the directory where data assocaited with plots
#' will be saved.
#'
#' @param dir A directory where to save plot data. If NULL,
#' plot data will not be saved.
#'
#' This functions sets the `plot_data_dir` chunk option in knitr.
#' You can get the same behaviour with `knitr::opts_chunk$set(plot_data_dir = dir)`.
#' However, if you use that code, you'll need to call `library(ggdatasaver)`
#' explicitly for the package to work.
#'
#' @export
plot_data_dir_set <- function(dir = NULL) {
  knitr::opts_chunk$set(plot_data_dir = dir)
}
