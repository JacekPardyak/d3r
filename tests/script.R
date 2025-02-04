system('Rscript ./tests/scripts/script.R')

system("quarto render ./tests/md/document.qmd")

system('Rscript -e "rmarkdown::render(\\"./tests/md/document.Rmd\\")"')

system('Rscript -e "shiny::runApp(\\"./tests/shiny/app.R\\", launch.browser = TRUE)"')

#Sys.setenv('_R_CHECK_SYSTEM_CLOCK_' = 0)
