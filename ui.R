
library(shiny)

shinyUI(fluidPage(
  titlePanel("d3vennR demo"),

  fluidRow(
    column(width = 6, 
           d3vennROutput("venn")
           ),
    column(width = 6,
           tableOutput("table")
           )
  )
))
