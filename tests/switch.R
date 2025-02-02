

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

