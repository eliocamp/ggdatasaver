.onLoad <- function(libname, pkgname){

  # Register knitr_print.gg as a method when the package is
  # loaded.

  registerS3method(
    "knit_print", "gg", knitr_print.gg,
    envir = asNamespace("knitr")
  )
}

# from https://stackoverflow.com/questions/48024266/save-a-data-frame-with-list-columns-as-csv-file
set_lists_to_chars <- function(x) {
  if (inherits(x, "list")) {
    y <- paste(unlist(x[1]), sep="", collapse=", ")
  } else {
    y <- x 
  }
  return(y)
}


parse_list_columns <- function(x) {
  data.frame(lapply(x, set_lists_to_chars), stringsAsFactors = FALSE)
}
