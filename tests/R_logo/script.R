system('"C:\\Program Files\\Inkscape\\bin\\python.exe" "C:\\Program Files\\Inkscape\\share\\inkscape\\extensions\\dxf_outlines.py" --output "C:\\Users\\jacek\\OneDrive\\Documents\\d3r\\tests\\R_logo\\Rlogo.dxf" "C:\\Users\\jacek\\OneDrive\\Documents\\d3r\\tests\\R_logo\\Rlogo.svg"')

library(sf)
library(dplyr)
library(jsonlite)
library(ggplot2)
library(d3r)

df <- sf::st_read("./tests/R_logo/Rlogo.dxf")
df |> select(geometry) |> plot()
df |> select(geometry) |> st_write("./tests/R_logo/Rlogo.geojson", append=FALSE)

result = tibble()
for (i in c(1:nrow(df))) {
    tmp = df |> select(geometry) |> slice(i) |> pull() |>
      st_coordinates() |>
      as_tibble() |>
      select(X, Y) |> rename(x = X, y = Y)
    result <- result |> bind_rows(tmp)
}

result <- result |>
  distinct() |>
  mutate(y = -y + 561) # flip and translate

breaks = c(125, 249, 474)
result <- result |> mutate(path = if_else(row_number() <  breaks[1], 1,
                                  if_else(row_number() >= breaks[1] & row_number() < breaks[2], 2,
                                  if_else(row_number() >= breaks[2] & row_number() < breaks[3], 3, 4))))

# plot path
result |> filter(path == 4) |>
  ggplot() +
  aes(x = x, y = y) +
  geom_path(color = "blue", linewidth = 1) +  # Line
  geom_point(color = "red", size = 3) +  # Points
  labs(title = "LINESTRING Plot", x = "X Coordinate", y = "Y Coordinate") +
  coord_fixed(ratio = 1) +
  theme_minimal()

data = result |> toJSON()
data|> write("./tests/R_logo/Rlogo.json")

data


style = '
svg {
    border: 1px solid black;
}

.outerPolygonE {
    fill: #CBCED0;
    stroke: none;
    stroke-width: none;
}

.outerPolygonR {
    fill: #276DC3;
    stroke: none;
    stroke-width: none;
}

.innerPolygon {
    fill: white;
    stroke: none;
    stroke-width: none;
}
'

'const width = 724, height = 561;

const svg = d3.select("#container")
            .append("svg")
            .attr("width", width)
            .attr("height", height);

const g = svg.append("g"); //.attr("transform", "translate(0, 561)");

const outerDataE = data.filter(d => d.path === 1);
const innerDataE = data.filter(d => d.path === 2);
const outerDataR = data.filter(d => d.path === 3);
const innerDataR = data.filter(d => d.path === 4);

// Function to convert data to path string
function getPathData(data) {
  return "M" + data.map(d => `${d.x},${d.y}`).join(" ") + " Z";
  }

// Draw outer polygon ellipse
let outerPolygonE = g.append("path")
            .attr("d", getPathData(outerDataE))
            .attr("class", "outerPolygonE");
// Draw inner polygon ellipse
let innerPolygonE = g.append("path")
            .attr("d", getPathData(innerDataE))
            .attr("class", "innerPolygon");
// Draw outer polygon letter R
let outerPolygonR = g.append("path")
            .attr("d", getPathData(outerDataR))
            .attr("class", "outerPolygonR");
// Draw inner polygon letter R
let innerPolygonR = g.append("path")
            .attr("d", getPathData(innerDataR))
            .attr("class", "innerPolygon");
// Define zoom behavior
const zoom = d3.zoom()
    .scaleExtent([0.5, 5]) // Min and max zoom scale
    .on("zoom", (event) => {
        g.attr("transform", event.transform);
    });

// Apply zoom behavior to the SVG element
svg.call(zoom);

' |> make(mode = "RStudio", style = style, data = data)


