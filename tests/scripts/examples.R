# Create SVG elements from data
title = 'd3r example' # Title in H2

style = 'svg {background-color: #D0D0D0;}' # CSS Style

data = '[
  { name: "Ireland", income: 53000, life: 78, pop: 6378, color: "black" },
  { name: "Norway", income: 73000, life: 87, pop: 5084, color: "blue" },
  { name: "Tanzania", income: 27000, life: 50, pop: 3407, color: "grey" }
]' # Data in JSON

script = 'const width = 120, height = 120;
const svg = d3.select("#container").append("svg").attr("width", width).attr("height", height);
svg.selectAll("circle").data(data).join("circle")      // binds and joins data to the selection and creates circle elements for each individual data
.attr("id", function(d) { return d.name })            // set the circle`s id according to the country name
        .attr("cx", function(d) { return d.income / 1000  })  // set the circle`s horizontal position according to income
.attr("cy", function(d) { return d.life })            // set the circle`s vertical position according to life expectancy
        .attr("r",  function(d) { return d.pop / 1000 *2 })   // set the circle`s radius according to country`s population
        .attr("fill", function(d) { return d.color });        // set the circle`s color according to country`s color
'

d3r::make(script = script, dir = "tests", style = style, data = data, title = title) #mode = 'RStudio'

Sys.setenv('_R_CHECK_SYSTEM_CLOCK_' = 0)
