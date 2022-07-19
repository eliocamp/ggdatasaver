#' Saves data associated with a ggplot plot
#'
#' Takes a ggplot and saves a zip file with a single csv
#' file for each layer of the plot with the data used by
#' said layer
#'
#' @param plot A ggplot2 plot.
#' @param name The name used as file name.
#' @param dir Directory where to put the file. If NUL
#'
#'
#' In general, you don't need to call this function
#' explicitly, since it will be used automatically by knitr
#' if the plot data directory is set (see [save_plot_data_in()]).
#'
#' Paraphrasing Voltaire, if `dir` doesn't exist,
#' it will be created. If the file already exists, it will
#' be overwritten without a warning. This is because this
#' function is supposed to run with knitr every time a document
#' is knit and will update the data to the latest version.
#'
#' @export
save_plot_data <- function(plot, name = "plot", dir = ".") {
  UseMethod("save_plot_data")
}

#' @export
save_plot_data.patchwork <- function(plot, name = "plot", dir = ".") {
  n_patches <- length(plot$patches$plots) +1

  for (i in seq_len(n_patches)) {
    save_plot_data(plot[[i]], name = paste0(name, "-", i), dir = dir)  
  }
}

#' @export
save_plot_data.gg <- function(plot, name = "plot", dir = ".") {
  if (!dir.exists(dir)) {
    dir.create(dir)
  }

  # Build the ggplot2 plot.
  gg <- suppressMessages(suppressWarnings(ggplot2::ggplot_build(plot)))

  # Get the data of each layer into a list
  datas <- gg[["data"]]

  # Get the name of the geom in each layer
  geom_names <- vapply(gg[["plot"]][["layers"]],
                       function(x) class(x[["geom"]])[1],
                       FUN.VALUE = character(1)
  )

  geom_names <- make.unique(geom_names, sep = "_")

  # Save the data of each label into its own file
  temp <- tempdir(TRUE)
  files <- vapply(seq_along(datas),
                  function(l) {
                    file <- file.path(temp, paste0(geom_names[l], ".csv"))
                    utils::write.csv(parse_list_columns(datas[[l]]), file, row.names = FALSE)
                    file
                  },
                  FUN.VALUE = character(1)
  )
  
  # Save the layout parameters. 
  layout_file <- file.path(temp, "layout.csv")
  utils::write.csv(gg[["layout"]][["layout"]], layout_file, row.names = FALSE)
  files <- c(files, layout_file)
  
  # zip them. 
  zipfile <- file.path(dir, paste0(name, ".zip"))
  if (file.exists(zipfile)) {
    file.remove(zipfile)
  }
  utils::zip(zipfile,
      files = files,
      flags = "-r9Xj"  # To "flatten" the files
  )
  return(invisible(NULL))
}

knitr_print.gg <- function(x, options, ...) {
  if (!is.null(options$plot_data_dir)) {
    last_label <- get_last_label()
    set_last_label(options$label)

    if (last_label == options$label) {  # We have many figures
      n_figs <- get_n_labels() + 1
    } else {
      n_figs <- 1
    }
    set_n_labels(n_figs)
    label <- paste0(options$label, "-", n_figs)
    save_plot_data(x, label, options$plot_data_dir)
  }

  NextMethod("knitr_print")
}


