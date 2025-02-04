#' Make HTML from D3.js script
#'
#' This function serves D3.js output in Quarto, Shiny, Jupyter, RStudio or HTML.
#' For debugging use `Source` > `Console` in your browser.
#'
#' @param script JavaScript string
#' @param style (optional) CSS string
#' @param html (optional) HTML template string
#' @param data (optional) JSON string. This adds line `const data = <your_data>;` to the JavaScript.
#' @param title (optional) Title
#' @param dir (optional) Directory to store HTML file
#' @param mode Available modes: NULL, Jupyter, RStudio, Quarto, Shiny"
#' @param width (optional) iframe width for Shiny and Quarto
#' @param height (optional) iframe height for Shiny and Quarto
#' @return HTML document presentation appropriate to the `mode`
#' @examples
#' # Create SVG elements from data
#' title = 'd3r example' # Title in H2
#' style = 'svg {background-color: #D0D0D0;}' # CSS Style
#' data = '[
#' { name: "Ireland", income: 53000, life: 78, pop: 6378, color: "black" },
#' { name: "Norway", income: 73000, life: 87, pop: 5084, color: "blue" },
#' { name: "Tanzania", income: 27000, life: 50, pop: 3407, color: "grey" }]'
#' script = 'const width = 120, height = 120;
#' const svg = d3.select("#container").append("svg").attr("width", width).attr("height", height);
#' svg.selectAll("circle").data(data).join("circle")     // for each data row create circle
#' .attr("id", function(d) { return d.name })            // set country name as circle identifier
#' .attr("cx", function(d) { return d.income / 1000  })  // set income as circle cx
#' .attr("cy", function(d) { return d.life })            // set life expectancy as circle cy
#' .attr("r",  function(d) { return d.pop / 1000 *2 })   // set country`s population as circle r
#' .attr("fill", function(d) { return d.color });        // set country`s color as circle fill color
#' '
#' make(script = script, dir = "tests", style = style, data = data, title = title)
#'
#' @export
make = function(script,
                style = NULL,
                html = NULL,
                data = NULL,
                title = NULL,
                mode = NULL,
                dir = NULL,
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

  if(is.null(dir)){dir = ''}
  if (is.null(mode)) {serve_html(html, dir); return() }

  mode <- tolower(mode)  # Normalize mode input

  switch(mode,
         "jupyter"   = IRdisplay::display_html(html),  # Jupyter mode
         "rstudio"   = serve_rstudio(html),  # RStudio mode
         "quarto"    = serve_quarto(html, dir = dir, width = width, height = height),  # Quarto mode
         "shiny"     = serve_shiny(html, width = width, height = height),  # Shiny mode
         {
           message("Invalid mode. Available modes: NULL, Jupyter, RStudio, Quarto, Shiny")
         }
  )}


