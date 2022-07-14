# Mimics ggplot2's last_plot()
.label_store <- function() {
  .last_label <- ""
  .n_labels <- 1

  list(
    get = function() .last_label,
    set = function(value) .last_label <<- value,

    n_get = function() .n_labels,
    n_set = function(value) .n_labels <<- value
  )
}

.store <- .label_store()


set_last_label <- function(value) .store$set(value)

get_last_label <- function() .store$get()

get_n_labels <- function() .store$n_get()

set_n_labels <- function(value) .store$n_set(value)

