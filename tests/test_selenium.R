# Take a screenshot
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
'  |> make(title = "D3.js in R", mode = "selenium") # |> rstudioapi::viewer()
