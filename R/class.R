#' d3r: R6 Class for D3.js
#'
#' @description
#' This class serves D3.js output in R ecosystem.
#' @examples
#' # Usage Example:
#' chart <- d3r$new(
#'   script = 'console.log(`Hello, ${data[0]}`);',
#'   title = "Check the Browser Console (F12 → Console Tab)",
#'   mode = NULL,
#'   data = jsonlite::toJSON(Sys.info()[["user"]])
#'   )
#' chart$make()
#' file.remove("index.html")
#' @importFrom R6 R6Class
#' @export
d3r <- R6::R6Class("d3r",
               public = list(
                 script = NULL,
                 style = NULL,
                 html = NULL,
                 data = NULL,
                 title = NULL,
                 mode = NULL,
                 dir = NULL,
                 width = 600,
                 height = 400,
                 # Constructor
                 #' @description Initialize the class with default values.
                 #' @field script description
                 #' @param script description script A character string (default is "default").
                 #' @field style description
                 #' @param style description
                 #' @field html description
                 #' @param html description
                 #' @field data description
                 #' @param data description
                 #' @field title description
                 #' @param title description
                 #' @field mode description
                 #' @param mode description
                 #' @field dir description
                 #' @param dir description
                 #' @field width description
                 #' @param width description
                 #' @field height description
                 #' @param height description
                 initialize = function(script, style = NULL, html = NULL, data = NULL, title = NULL,
                                       mode = NULL, dir = NULL, width = 600, height = 400) {
                   self$script <- script
                   self$style <- style %||% ''
                   self$html <- html
                   self$data <- data
                   self$title <- title
                   self$mode <- mode
                   self$dir <- dir
                   self$width <- width
                   self$height <- height
                 },
                 # Generate HTML template
                 #' @description generate_html the class with default values.
                 generate_html = function() {
                   if (is.null(self$html)) {
                     self$html <- '
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
'
                   }
                   script <- self$script

                   if (!is.null(self$title)) {
                     title_script <- sprintf('// Set title
d3.select("#container")
  .insert("h2", ":first-child")
  .text("%s");', self$title)
                     script <- paste(title_script, script, sep = '\n')
                   }

                   if (!is.null(self$data)) {
                     data_script <- sprintf('// Inject data
const data = %s;', self$data)
                     script <- paste(data_script, script, sep = '\n')
                   }

                   sprintf(self$html, self$style, script)
                 },

                 # Render HTML
                 #' @description make the class with default values.
                 make = function() {
                   html <- self$generate_html()

                   if (is.null(self$dir)) self$dir <- ''

                   if (is.null(self$mode)) {
                     serve_html(html, self$dir)
                     return()
                   }

                   mode <- tolower(self$mode)

                   switch(mode,
                          "jupyter"   = IRdisplay::display_html(html),
                          "rstudio"   = serve_rstudio(html),
                          "quarto"    = serve_quarto(html, dir = self$dir, width = self$width, height = self$height),
                          "shiny"     = serve_shiny(html, width = self$width, height = self$height),
                          "selenium"  = serve_selenium(html),
                          message("Invalid mode. Available modes: NULL, Jupyter, RStudio, Quarto, Shiny, Selenium")
                   )
                 }
               )
               #,
               #private = list(
              #   serve_rstudio = function(html){
              #     temp <- tempfile(fileext = '.html')
              #     writeLines(html, temp)
              #     rstudioapi::viewer(temp)
              #   }
             #)
)


