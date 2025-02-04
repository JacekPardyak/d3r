style = '
.tooltip {
	position: absolute;
	text-align: center;
	padding: 12px;
	font: 15px sans-serif;
	background: lightsteelblue;
	border-radius: 11px;
	border-radius: 8px;
	pointer-events: none;
}


'

script = '
// Function to visualize (e.g., sine wave)
function f(x) {
  return Math.sin(x) * Math.cos(x);
}

// Tooltip
const tooltip = d3.select("body")
      .append("div")
      .attr("class", "tooltip");

// Create SVG inside the div
const width = 600;
const height = 400;
const margin = 40;

const svg = d3.select("#container")
  .append("svg")
  .attr("width", width)
  .attr("height", height);

// Generate data points
const data = d3.range(-Math.PI, Math.PI, 0.05).map(x => ({ x, y: f(x) }));

// Define scales
const xScale = d3.scaleLinear().domain([-Math.PI, Math.PI]).range([margin, width - margin]);
const yScale = d3.scaleLinear().domain([-1, 1]).range([height - margin, margin]);

// define group
let g = svg.append("g");

// Define line generator
const line = d3.line()
  .x(d => xScale(d.x))
  .y(d => yScale(d.y));

// Append path for line
g.append("path")
  .datum(data)
  .attr("fill", "none")
  .attr("stroke", "steelblue")
  .attr("stroke-width", 2)
  .attr("d", line);

	g.selectAll("circle")
		.data(data)
		.join("circle")
		.attr("cx", d => xScale(d.x))
    .attr("cy", d => yScale(d.y))
		.attr("r", 5)
		.style("fill", "#191970")
		.on("mouseover", function (event, d) {
			tooltip.transition().duration(200).style("opacity", 0.6);
			tooltip
				.html(`(x, y): (${d.x.toFixed(2)}, ${d.y.toFixed(2)})`)
				.style("left", event.pageX + "px")
				.style("top", event.pageY - 28 + "px");
		})
		.on("mouseout", function (d) {
			tooltip.transition().duration(500).style("opacity", 0);
		});

// Zooming
let zooming = d3
		.zoom()
		.scaleExtent([1, 8])
		.extent([
			[0, 0],
			[width, height]
		])
		.on("zoom", function (event) {
			g.selectAll("path").attr("transform"
			  ,event.transform)
			  .attr("stroke-width", 5 / event.transform.k);
			g.selectAll("circle")
				.attr("transform", event.transform)
				.attr("r", 5 / event.transform.k);
		});

svg.call(zooming);


'


make(script = script, mode = "RStudio", style = style, title = "D3.js chart with zoom & tooltip")



