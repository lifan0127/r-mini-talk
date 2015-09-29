
library(shiny)

shinyUI(pageWithSidebar(

  headerPanel("d3vennR demo"),

  sidebarPanel(
    p("This is a demo of the d3vennR pacakge.")
  ),
  
  mainPanel(
    d3vennROutput("venn")
  )
))
