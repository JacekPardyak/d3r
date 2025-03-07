% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make.R
\name{make}
\alias{make}
\title{Make HTML from D3.js script}
\usage{
make(
  script,
  style = NULL,
  html = NULL,
  data = NULL,
  title = NULL,
  mode = NULL,
  dir = NULL,
  width = 600,
  height = 400
)
}
\arguments{
\item{script}{JavaScript string}

\item{style}{(optional) CSS string}

\item{html}{(optional) HTML template string}

\item{data}{(optional) JSON string. This adds line \verb{const data = <your_data>;} to the JavaScript.}

\item{title}{(optional) Title}

\item{mode}{Available modes: NULL, Jupyter, RStudio, Quarto, Shiny, Selenium
\itemize{
\item If mode = \code{NULL}, the HTML is served directly in \code{dir/index.html}.
\item If mode = \code{jupyter}, the output is displayed in Jupyter Notebook.
\item If mode = \code{rstudio}, it will attempt to render inside RStudio.
\item If mode = \code{quarto}, it will render in Quarto with the specified HTML iframe width/height.
\item If mode = \code{shiny}, it will render as a Shiny component with the specified iframe width/height.
\item If mode = \code{selenium}, it will use Selenium to extract produced SVG.
}}

\item{dir}{(optional) Directory to store HTML/SVG file}

\item{width}{(optional) iframe width for Shiny and Quarto iframe}

\item{height}{(optional) iframe height for Shiny and Quarto iframe}
}
\value{
HTML document presentation appropriate to the \code{mode}
}
\description{
This function serves D3.js output in Quarto, Shiny, Jupyter, RStudio or HTML.
For debugging use \code{Source} > \code{Console} in your browser.
}
\examples{
# Create SVG elements from data
title = 'd3r example' # Title in H2
style = 'svg {background-color: #D0D0D0;}' # CSS Style
data = '[
{ name: "Ireland", income: 53000, life: 78, pop: 6378, color: "black" },
{ name: "Norway", income: 73000, life: 87, pop: 5084, color: "blue" },
{ name: "Tanzania", income: 27000, life: 50, pop: 3407, color: "grey" }]'
script = 'const width = 120, height = 120;
const svg = d3.select("#container").append("svg").attr("width", width).attr("height", height);
svg.selectAll("circle").data(data).join("circle")     // for each data row create circle
.attr("id", function(d) { return d.name })            // set country name as circle identifier
.attr("cx", function(d) { return d.income / 1000  })  // set income as circle cx
.attr("cy", function(d) { return d.life })            // set life expectancy as circle cy
.attr("r",  function(d) { return d.pop / 1000 *2 })   // set country`s population as circle r
.attr("fill", function(d) { return d.color });        // set country`s color as circle fill color
'
make(script = script, dir = "tests", style = style, data = data, title = title)

}
