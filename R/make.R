#' Load a Matrix
#'
#' This function loads a file as a matrix. It assumes that the first column
#' contains the rownames and the subsequent columns are the sample identifiers.
#' Any rows with duplicated row names will be dropped with the first one being
#' kepted.
#'
#' @param script Path to the input file
#' @param style Path to the input file
#' @param html Path to the input file
#' @param data Path to the input file
#' @param title Path to the input file
#' @param mode Path to the input file
#' @param width iframe width
#' @param height Path to the input file
#' @return A matrix of the infile
#' @export
make = function(script, style = NULL, html = NULL, data = NULL, title = NULL,
                mode = NULL,
                width = 600,
                height = 400) {
  # data must be JSON. Character " will be replaced with '
  if(is.null(html)){
    html = '
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>d3r</title>
    <script src="https://d3js.org/d3.v7.min.js"></script>
    <style>%s</style>
</head>
<body>
    <div id="container"></div>
    <script>%s</script>
</body>
</html>
'}
  if(is.null(style)){style = ''}

  if(!is.null(title)){
    title = paste0('// Set title
d3.select("#container")
  .insert("h2", ":first-child")
  .text("', title, '"); ')
    script = paste(title, script, sep = '\n')
  }

  if(!is.null(data)){
    data = paste0('// Inject data
const data = ', data, ';')
    script = paste(data, script, sep = '\n')
  }


  html = sprintf(html, style, script)

  # NULL mode
  if(is.null(mode)){html |> writeLines('index.html')}
  else {
    # IRdisplay - R kernel and R magic (Kaggle, Colab, etc) mode
    if(tolower(mode) == 'irdisplay'){html |> IRdisplay::display_html()}
    # RStudio mode
    if(tolower(mode) == 'rstudio'){
      temp <- tempfile(fileext = '.html')
      html |> writeLines(temp)
      rstudioapi::viewer(temp)}
    # Quarto mode. IMPORTANT: #| results: asis
    if(tolower(mode) == 'quarto'){ html |> prepare_quarto(width = width, height = height)}
    # Shiny mode.
    if(tolower(mode) == 'shiny'){ html |> prepare_shiny(width = width, height = height)}
  }
}

