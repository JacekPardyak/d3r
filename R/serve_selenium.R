#' Serve D3.js in Selenium
#'
#' This function serves D3.js output in Selenium and returns SVG (before: takes screenshot)
#'
#' @param html HTML string
#' @param dir SVG output directory
#' @return path of the SVG file (before: screenshot PNG file)
#' @export

serve_selenium <- function(html, dir){
  temp_html <- tempfile(fileext = ".html")
  #temp_png <- tempfile(fileext = ".png")
  temp_svg <- tempfile(fileext = ".svg")
  writeLines(html, temp_html)
  temp_html <- utils::URLencode(paste0("file:///", normalizePath(temp_html, winslash = "/")))
  session <- selenider::selenider_session()
  selenider::open_url(temp_html)
  #selenider::take_screenshot(temp_png)
  element <- session |> selenider::find_element("svg")
  element <- rvest::read_html(element) |> rvest::html_element("svg")
  # Add the missing xmlns attribute to the <svg> tag
  xml2::xml_attr(element, "xmlns") <- "http://www.w3.org/2000/svg"
  element <- as.character(element)
  writeLines(element, temp_svg)
  file_name <- basename(temp_svg)
  output_dir <- file.path(getwd(), dir)
  if (!dir.exists(output_dir)) dir.create(output_dir)  # Create if it doesn't exist
  new_svg <- file.path(output_dir, file_name)
  file.copy(temp_svg, new_svg, overwrite = TRUE)
  new_svg
}


