#' Serve D3.js in Quarto
#'
#' This function serves D3.js output in Quarto
#'
#' @param html HTML string
#' @param dir Directory for HTML file
#' @param width iframe width
#' @param height iframe height
#' @return Iframe embedded in Quarto or R Markdown document
#' @export

serve_quarto <- function(html, dir, width, height){
  temp_html <- tempfile(fileext = ".html")
  file_name <- basename(temp_html)
  writeLines(html, temp_html)
  output_dir <- file.path(getwd(), dir)
  if (!dir.exists(output_dir)) dir.create(output_dir)  # Create if it doesn't exist
  new_html_path <- file.path(output_dir, file_name)
  file.copy(temp_html, new_html_path, overwrite = TRUE)
  relative_path <- file.path(dir, file_name)
  string = paste0('<iframe src="', relative_path,'" width=', width,  ', height=', height, '></iframe>')
  cat(string)
}
