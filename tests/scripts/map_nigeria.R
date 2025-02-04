style = '
body {
	background: lightblue;
	position: relative;
	height: 100vh;
}
button {
	outline: 0px;
	border: 0px;
	cursor: pointer;
	outline-style: none;
}
path {
	stroke: white;
	stroke-width: 0.5px;
	fill: #ebebe0;
}

#float-button-group {
	position: absolute;
	left: 10px;
	top: 10px;
	opacity: 0.5;
	display: flex;
	flex-direction: column;
}

#float-button-group:hover {
	opacity: 1;
}
.svg-icon {
	width: 1.5em;
	height: 1.5em;
}
.svg-icon path,
.svg-icon polygon,
.svg-icon rect {
	fill: #333;
}
.btn-default {
	color: #333;
	background-color: #fff;
	border-color: #ccc;
	padding: 0.4rem;
}
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
// import * as d3 from "https://cdn.skypack.dev/d3";

// set the dimensions and margins of the graph
const margin = { top: 0, right: 0, bottom: 0, left: 0 };
const width = document.querySelector("body").clientWidth;
const height = document.querySelector("body").clientHeight;

// Create SVG inside the div
const svg = d3.select("#container")
  .append("svg")
  .attr("width", width)
  .attr("height", height)
  .attr("viewBox", [0, 0, width, height]);
// add title
svg
	.append("text")
	.attr("x", width / 1.4)
	.attr("y", `${height - 20}`)
	.style("font-size", "20x")
	.style("text-decoration", "underline")
	.text("Map of Nigeria and it`s states ");

let projection = d3.geoEquirectangular().center([0, 0]);
const pathGenerator = d3.geoPath().projection(projection);

let g = svg.append("g");

let tooltip = d3
	.select("body")
	.append("div")
	.attr("class", "tooltip")
	.style("opacity", 0);

Promise.all([
	d3.json(
		"https://raw.githubusercontent.com/iamspruce/intro-d3/main/data/nigeria_state_boundaries.geojson"
	),
	d3.json(
		"https://raw.githubusercontent.com/iamspruce/intro-d3/main/data/nigeria-states.json"
	)
]).then(([topoJSONdata, countryData]) => {
	countryData.data.forEach((d) => {
		d.info.Longitude = +d.info.Longitude;
		d.info.Latitude = +d.info.Latitude;
	});
	projection.fitSize([width, height], topoJSONdata);
	g.selectAll("path")
		.data(topoJSONdata.features)
		.join("path")
		.attr("class", "country")
		.attr("d", pathGenerator);

	g.selectAll("circle")
		.data(countryData.data)
		.join("circle")
		.attr("cx", (d) => projection([d.info.Longitude, d.info.Latitude])[0])
		.attr("cy", (d) => projection([d.info.Longitude, d.info.Latitude])[1])
		.attr("r", 5)
		.style("fill", "green")
		.on("mouseover", function (event, d) {
			tooltip.transition().duration(200).style("opacity", 0.9);
			tooltip
				.html(`<p>Population: ${d.info.Population}</a>` + `<p>Name: ${d.Name}</p>`)
				.style("left", event.pageX + "px")
				.style("top", event.pageY - 28 + "px");
		})
		.on("mouseout", function (d) {
			tooltip.transition().duration(500).style("opacity", 0);
		});

	g.selectAll("text")
		.data(countryData.data)
		.join("text")
		.attr("x", (d) => projection([d.info.Longitude, d.info.Latitude])[0])
		.attr("y", (d) => projection([d.info.Longitude, d.info.Latitude])[1])
		.attr("dy", -7)
		.style("fill", "black")
		.style("font-size", "18px")
		.attr("text-anchor", "middle")
		.text((d) => d.Name);

	let zooming = d3
		.zoom()
		.scaleExtent([1, 8])
		.extent([
			[0, 0],
			[width, height]
		])
		.on("zoom", function (event) {
			g.selectAll("path").attr("transform", event.transform);
			g.selectAll("circle")
				.attr("transform", event.transform)
				.attr("r", 5 / event.transform.k);
			g.selectAll("text")
				.attr("transform", event.transform)
				.style("font-size", `${18 / event.transform.k}`)
				.attr("dy", -7 / event.transform.k);
		});

	svg.call(zooming);

	d3.select("#zoomIn").on("click", () => {
svg.transition().call(zooming.scaleBy, 2);
});
d3.select("#zoomOut").on("click", () => {
  svg.transition().call(zooming.scaleBy, 0.5);
});
d3.select("#resetZoom").on("click", () => {
  svg.transition().call(zooming.scaleTo, 0);
});
});

// Create the button group
d3.select("body")
  .append("div")
  .attr("class", "btn-group-vertical")
  .attr("role", "group")
  .attr("aria-label", "...")
  .attr("id", "float-button-group")
  .selectAll("button")
  .data([
    { id: "zoomIn", title: "Zoom In", path: "M13.388,9.624h-3.011v-3.01c0-0.208-0.168-0.377-0.376-0.377S9.624,6.405,9.624,6.613v3.01H6.613c-0.208,0-0.376,0.168-0.376,0.376s0.168,0.376,0.376,0.376h3.011v3.01c0,0.208,0.168,0.378,0.376,0.378s0.376-0.17,0.376-0.378v-3.01h3.011c0.207,0,0.377-0.168,0.377-0.376S13.595,9.624,13.388,9.624z M10,1.344c-4.781,0-8.656,3.875-8.656,8.656c0,4.781,3.875,8.656,8.656,8.656c4.781,0,8.656-3.875,8.656-8.656C18.656,5.219,14.781,1.344,10,1.344z M10,17.903c-4.365,0-7.904-3.538-7.904-7.903S5.635,2.096,10,2.096S17.903,5.635,17.903,10S14.365,17.903,10,17.903z" },
    { id: "zoomOut", title: "Zoom Out", path: "M10,1.344c-4.781,0-8.656,3.875-8.656,8.656c0,4.781,3.875,8.656,8.656,8.656c4.781,0,8.656-3.875,8.656-8.656C18.656,5.219,14.781,1.344,10,1.344z M10,17.903c-4.365,0-7.904-3.538-7.904-7.903S5.635,2.096,10,2.096S17.903,5.635,17.903,10S14.365,17.903,10,17.903z M13.388,9.624H6.613c-0.208,0-0.376,0.168-0.376,0.376s0.168,0.376,0.376,0.376h6.775c0.207,0,0.377-0.168,0.377-0.376S13.595,9.624,13.388,9.624z" },
    { id: "resetZoom", title: "Reset Zoom", path: "M17.659,9.597h-1.224c-0.199-3.235-2.797-5.833-6.032-6.033V2.341c0-0.222-0.182-0.403-0.403-0.403S9.597,2.119,9.597,2.341v1.223c-3.235,0.2-5.833,2.798-6.033,6.033H2.341c-0.222,0-0.403,0.182-0.403,0.403s0.182,0.403,0.403,0.403h1.223c0.2,3.235,2.798,5.833,6.033,6.032v1.224c0,0.222,0.182,0.403,0.403,0.403s0.403-0.182,0.403-0.403v-1.224c3.235-0.199,5.833-2.797,6.032-6.032h1.224c0.222,0,0.403-0.182,0.403-0.403S17.881,9.597,17.659,9.597 M14.435,10.403h1.193c-0.198,2.791-2.434,5.026-5.225,5.225v-1.193c0-0.222-0.182-0.403-0.403-0.403s-0.403,0.182-0.403,0.403v1.193c-2.792-0.198-5.027-2.434-5.224-5.225h1.193c0.222,0,0.403-0.182,0.403-0.403S5.787,9.597,5.565,9.597H4.373C4.57,6.805,6.805,4.57,9.597,4.373v1.193c0,0.222,0.182,0.403,0.403,0.403s0.403-0.182,0.403-0.403V4.373c2.791,0.197,5.026,2.433,5.225,5.224h-1.193c-0.222,0-0.403,0.182-0.403,0.403S14.213,10.403,14.435,10.403" }
  ])
  .enter()
  .append("button")
  .attr("class", "btn-default")
  .attr("id", d => d.id)
  .html(d => `<svg class=\"svg-icon\" viewBox=\"0 0 20 20\"><title>${d.title}</title><path fill=\"none\" d=\"${d.path}\"></path></svg>`);
'


make(script = script, mode = "RStudio", style = style)



