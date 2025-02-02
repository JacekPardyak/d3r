

mode = "cola"

test <- function(mode) {
if (is.null(mode)) {
  print("null")
  return()
}
  switch(mode,
         "irdisplay" = print("irdisplay"),
         "rstudio" = print("rstudio"),
         {print("select some")})


}

test(mode = NULL)
test(mode = "cola")

library(d3r)
'// Set SVG dimensions
const width = 400, height = 300;

// Create SVG inside the div
const svg = d3.select("#container")
  .append("svg")
  .attr("width", width)
  .attr("height", height);

// Append a circle
svg.append("circle")
  .attr("cx", 200)  // X position
  .attr("cy", 150)  // Y position
  .attr("r", 50)    // Radius
  .attr("fill", "steelblue");  // Color
'  |> make(mode = 'RStudio', title = "Circle in RStudio")
