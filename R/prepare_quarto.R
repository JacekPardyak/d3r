#' Load a Matrix
#'
#' This function loads a file as a matrix. It assumes that the first column
#' contains the rownames and the subsequent columns are the sample identifiers.
#' Any rows with duplicated row names will be dropped with the first one being
#' kepted.
#'
#' @param html Path to the input file
#' @param dir description
#' @param width description
#' @param height description
#' @return A matrix of the infile
#' @export

prepare_quarto <- function(html, dir = "html_output", width, height){
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
