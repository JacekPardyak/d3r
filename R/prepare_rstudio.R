#' Load a Matrix
#'
#' This function loads a file as a matrix. It assumes that the first column
#' contains the rownames and the subsequent columns are the sample identifiers.
#' Any rows with duplicated row names will be dropped with the first one being
#' kepted.
#'
#' @param html HTML string
#' @return HTML displayed in RStudio Viewer
#' @export

prepare_rstudio <- function(html){
  temp <- tempfile(fileext = '.html')
  writeLines(html, temp)
  rstudioapi::viewer(temp)
}
