'const width = 600;
const height = 400;
const numPoints = 1000;

// Create Canvas
const canvas = d3.select("#container")
.append("canvas")
.attr("width", width)
.attr("height", height)
.node();

const ctx = canvas.getContext("2d");

// Generate random dataset
const data = d3.range(numPoints).map(() => ({
  x: Math.random() * width,
  y: Math.random() * height,
  color: d3.interpolateCool(Math.random()) // Color gradient
}));

// Function to draw points
function draw() {
  ctx.clearRect(0, 0, width, height);
  data.forEach(d => {
    ctx.beginPath();
    ctx.arc(d.x, d.y, 3, 0, 2 * Math.PI);
    ctx.fillStyle = d.color;
    ctx.fill();
  });
}

// Draw the scatterplot
draw();
' |> make(mode = "RStudio")
