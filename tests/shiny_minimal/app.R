library(shiny)
library(d3r)

# Define UI
ui <- fluidPage(
  titlePanel("Minimal Interactive Shiny App"),
  htmlOutput("d3r")
)

# Define Server
server <- function(input, output) {
  output$d3r <- renderUI({
    script = '
      const width = 400;
      const height = 200;
      const svg = d3.select("#container")
        .append("svg")
        .attr("width", width)
        .attr("height", height);
      // Append a circle
      const circle = svg.append("circle")
        .attr("cx", 200)
        .attr("cy", 100)
        .attr("r", 40)
        .attr("fill", "steelblue")
        .on("click", function() {
          // Change color on click
          d3.select(this).attr("fill", "tomato");
      });'
    make(script = script, mode = 'Shiny', width = 430, height = 230)
    })
}

# Run the App
shinyApp(ui = ui, server = server)


