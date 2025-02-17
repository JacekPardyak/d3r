#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

#dd <- faithful

faithful |> write.csv("./www/faithful.csv", row.names = FALSE)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           htmlOutput("d3r")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })

    output$d3r <- renderUI({
      script = '
const margin = { top: 20, right: 30, bottom: 40, left: 45 };
const width = 600 - margin.left - margin.right;
const height = 400 - margin.top - margin.bottom;

// Append SVG
const svg = d3.select("#container")
  .append("svg")
  .attr("width", 600)
  .attr("height", 400)
  .append("g")
  .attr("transform", `translate(${margin.left},${margin.top})`);

let binCount = data;

// Load CSV from www folder and process
d3.csv("faithful.csv").then(data => {
  data = data.map(d => +d.waiting);


  updateHistogram(binCount);

  function updateHistogram(bins) {
    svg.selectAll("*").remove(); // Clear existing plot

    const x = d3.scaleLinear()
      .domain(d3.extent(data))
      .range([0, width]);

    const histogram = d3.histogram()
      .domain(x.domain())
      .thresholds(x.ticks(bins));

    const binsData = histogram(data);

    const y = d3.scaleLinear()
      .domain([0, d3.max(binsData, d => d.length)])
      .range([height, 0]);

    svg.append("g")
      .attr("transform", `translate(0,${height})`)
      .call(d3.axisBottom(x));

    svg.append("g").call(d3.axisLeft(y));

    svg.selectAll("rect")
      .data(binsData)
      .join("rect")
      .attr("x", d => x(d.x0))
      .attr("y", d => y(d.length))
      .attr("width", d => x(d.x1) - x(d.x0) - 1)
      .attr("height", d => height - y(d.length))
      .attr("fill", "steelblue");

    // X-axis label
    svg.append("text")
      .attr("id", "xLabel")
      .attr("x", width / 2)
      .attr("y", height + margin.bottom - 5) // Ensure height is defined
      .attr("text-anchor", "middle")
      .style("font-size", "14px")
      .text("Waiting time to next eruption (in mins)");

    // Y-axis label
    svg.append("text")
      .attr("id", "yLabel")
      .attr("transform", "rotate(-90)")
      .attr("x", -height / 2)
      .attr("y", -margin.left + 15) // Adjust for spacing
      .attr("text-anchor", "middle")
      .style("font-size", "14px")
      .text("Frequency");
  }
});
'
      d3r::make(script = script, mode = 'Shiny', data = input$bins,
                title = 'Histogram of waiting times', width = 630, height = 490)
    })
}

# Run the application
shinyApp(ui = ui, server = server)
