library(shiny)
library(d3vennR)
library(readr)

movies <- read_csv("data/movies250.csv")

source("R/to-venn.R")

vennData <- toVenn(movies)

popover <- "
  function(){
    var div = d3.select(this);
    div.selectAll('path').style({'stroke-opacity': 0, 'stroke': '#09f', 'stroke-width': 0});

    div.selectAll('g')
    .on('mouseenter', function(d, i){
      venn.sortAreas(div, d);
      Shiny.onInputChange('hoveredGenre', d.sets);
      d3.select(this).select('path').style({'stroke-opacity': 1, 'stroke-width': 3});
    })
    .on('mouseleave', function(d, i){
      d3.select(this).select('path').style({'stroke-opacity': 0, 'stroke-width': 0});
    })
  }

"

shinyServer(function(input, output) {
   
  output$venn <- renderD3vennR({
    d3vennR(
      data = vennData, width = 460, fontSize = "1.2em",
      tasks = list(htmlwidgets::JS(popover))
    )
  })
  
  output$table <- renderTable({
    if(is.null(input$hoveredGenre)) return(NULL)
    
    selectedGenre <- genre[input$hoveredGenre + 1]
    print(selectedGenre)
    selectedMovies <- topMovieGenre %>%
      group_by(Rank) %>%
      filter(all(selectedGenre %in% Genre))
      
    if(nrow(selectedMovies) == 0) return(NULL)

    movies %>%
      filter(Rank %in% unique(selectedMovies$Rank)) %>%
      select(Title, Director, Year, Rating)
  })
  
}) 
