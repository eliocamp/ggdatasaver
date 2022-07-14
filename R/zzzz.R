.onLoad <- function(libname, pkgname){

  # Register knitr_print.gg as a method when the package is
  # loaded.

  registerS3method(
    "knit_print", "gg", knitr_print.gg,
    envir = asNamespace("knitr")
  )
}


