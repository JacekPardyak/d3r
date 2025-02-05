library(d3r)
# Usage Example:
chart <- d3r$new(
  script = 'console.log(`Hello, ${data[0]}`);',
  title = "Check the Browser Console (F12 → Console Tab)",
  mode = NULL,
  data = jsonlite::toJSON(Sys.info()[["user"]])
)

chart$make()
file.remove("index.html")
