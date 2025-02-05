
system("quarto render ./tests/md/document.qmd")

system("quarto render ./tests/md/document_minimal.qmd")

system('Rscript -e "rmarkdown::render(\\"./tests/md/document.Rmd\\")"')

system('Rscript -e "shiny::runApp(\\"./tests/shiny/app.R\\", launch.browser = TRUE)"')

system('Rscript -e "shiny::runApp(\\"./tests/shiny_minimal/app.R\\", launch.browser = TRUE)"')

#Sys.setenv('_R_CHECK_SYSTEM_CLOCK_' = 0)
