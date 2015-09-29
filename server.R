library(shiny)
library(d3vennR)
library(readr)

movies <- read_csv("data/movies250.csv")

source("R/to-venn.R")

vennData <- toVenn(movies)

shinyServer(function(input, output) {
   
  output$venn <- renderD3vennR({
    d3vennR(
      data = vennData, height = 460, width = 460, fontSize = "1.2em"
    )
  })
  
})
