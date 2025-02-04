#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Draw something with d3r"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
    ),

    # Show a plot of the generated distribution
    mainPanel(
      htmlOutput("d3r")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$d3r <- renderUI({
    style = 'svg {
  border: 1px solid black;}'

    '// Dimensions

      const width = 600;
      const height = 400;

      // Create SVG container
      const svg = d3.select("#container")
      .append("svg")
      .attr("width", width)
      .attr("height", height);

      let is_drawing = false;

      svg.on("mousemove", function(event) {
        var pos = d3.pointer(event, this);
          if (is_drawing) {
            svg.append("circle")
            .attr("cx", pos[0])
            .attr("cy", pos[1])
            .style("fill", "red")
            .attr("r", 3);
          }
      }).on("mousedown", function() {
        is_drawing = true;
      }).on("mouseup", function() {
        is_drawing = false;
      });

      // Create a separate div for the button
      const buttonContainer = d3.select("body")
      .append("div")
      .attr("id", "buttonContainer")
      .style("margin-top", "10px");

      // Add download button
      buttonContainer.append("button")
      .text("Download SVG")
      .on("click", function() {
        const serializer = new XMLSerializer();
        const svgBlob = new Blob([serializer.serializeToString(svg.node())], { type: "image/svg+xml;charset=utf-8" });
        const url = URL.createObjectURL(svgBlob);

        const link = document.createElement("a");
        link.href = url;
        link.download = "drawing.svg";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
      });
' |> make(mode = 'Shiny', style = style, width = 620, height = 480)
  })
}


# Run the application
shinyApp(ui = ui, server = server)
