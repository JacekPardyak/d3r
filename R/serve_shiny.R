#' Serve D3.js in Shiny
#'
#' This function serves D3.js output in Shiny
#'
#' @param html HTML string
#' @param width iframe width
#' @param height iframe height
#' @return Shiny HTML tag iframe
#' @export

serve_shiny <- function(html, width, height){
  dir = "www"
  temp_html <- tempfile(fileext = ".html")
  file_name <- basename(temp_html)
  writeLines(html, temp_html)
  output_dir <- file.path(getwd(), dir)
  if (!dir.exists(output_dir)) dir.create(output_dir)  # Create if it doesn't exist
  new_html_path <- file.path(output_dir, file_name)
  file.copy(temp_html, new_html_path, overwrite = TRUE)
  shiny::tags$iframe(seamless = "seamless",
                     src = file_name,
                     width = width,
                     height = height)
}
