#' Serve HTML
#'
#' This function saves D3.js output in a folder
#'
#' @param html HTML string
#' @param dir Directory for HTML file
#' @return File `index.html` in `dir` directory
#' @export

serve_html <- function(html, dir){
  output_dir <- file.path(getwd(), dir)
  if (!dir.exists(output_dir)) dir.create(output_dir)
  output_dir <- file.path(output_dir, "index.html")
  writeLines(html, output_dir)
}
