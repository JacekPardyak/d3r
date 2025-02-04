#' Serve D3.js in RStudio
#'
#' This function serves D3.js output in RStudio Viewer
#'
#' @param html HTML string
#' @return HTML displayed in RStudio Viewer
#' @export

serve_rstudio <- function(html){
  temp <- tempfile(fileext = '.html')
  writeLines(html, temp)
  rstudioapi::viewer(temp)
}
