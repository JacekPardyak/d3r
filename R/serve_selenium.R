#' Serve D3.js in Selenium
#'
#' This function serves D3.js output in Selenium and takes screenshot
#'
#' @param html HTML string
#' @return path of the screenshot PNG file
#' @export

serve_selenium <- function(html){
  temp_html <- tempfile(fileext = ".html")
  temp_png <- tempfile(fileext = ".png")
  writeLines(html, temp_html)
  temp_html <- utils::URLencode(paste0("file:///", normalizePath(temp_html, winslash = "/")))
  session <- selenider::selenider_session()
  selenider::open_url(temp_html)
  selenider::take_screenshot(temp_png)
}
