
toVenn <- function(movies){
  movieGenre <- movies %>%
    select(Rank, Genre) %>%
    rowwise() %>%
    do(data_frame(Rank = .$Rank, Genre = stri_split_fixed(.$Genre, ", ")[[1]])) %>%
    ungroup() 
  
  topMovieGenre <- movieGenre %>%
    filter(Genre %in% names(sort(table(movieGenre$Genre), decreasing = TRUE))[c(2, 3, 6, 8, 10, 11, 13, 16, 18)])
  
  
  genre <- sort(unique(topMovieGenre$Genre))
  
  genreDict <- structure(0:(length(genre)-1), names = genre)
  
  genreTable <- table(topMovieGenre$Genre)
  
  topGenre <- lapply(1:length(genre), function(i){
    list(sets = list(i-1), label = genre[i], size = as.integer(genreTable[i]))
  })
  
  
  topGenrePairDF <- structure(
    as.data.frame(t(combn(genre, 2)), stringsAsFactors = FALSE),
    names = c("One", "Two")
  ) %>%
    left_join(
      topMovieGenre %>%
        group_by(Rank) %>%
        filter(n() > 1) %>%
        do(as.data.frame(t(combn(.$Genre, 2)), stringsAsFactors = FALSE)) %>%
        ungroup() %>%
        transmute(One = V1, Two = V2) %>%
        group_by(One, Two) %>%
        summarize(Count = n()) %>%
        ungroup(),
      by = c("One", "Two")
    ) %>%
    mutate(Count = ifelse(is.na(Count), 0, Count))
  
  topGenrePair <- lapply(1:nrow(topGenrePairDF), function(i){
    list(sets = list(as.integer(genreDict[topGenrePairDF$One[i]]),
                     as.integer(genreDict[topGenrePairDF$Two[i]])), 
         size = topGenrePairDF$Count[i])
  })
  
  
  topGenreTripletDF <- structure(
    as.data.frame(t(combn(genre, 3)), stringsAsFactors = FALSE),
    names = c("One", "Two", "Three")
  ) %>%
    left_join(
      topMovieGenre %>%
        group_by(Rank) %>%
        filter(n() > 2) %>%
        do(as.data.frame(t(combn(.$Genre, 3)), stringsAsFactors = FALSE)) %>%
        ungroup() %>%
        transmute(One = V1, Two = V2, Three = V3) %>%
        group_by(One, Two, Three) %>%
        summarize(Count = n()) %>%
        ungroup(),
      by = c("One", "Two", "Three")
    ) %>%
    mutate(Count = ifelse(is.na(Count), 0, Count))
  
  topGenreTriplet <- lapply(1:nrow(topGenreTripletDF), function(i){
    list(sets = list(as.integer(genreDict[topGenreTripletDF$One[i]]),
                     as.integer(genreDict[topGenreTripletDF$Two[i]]),
                     as.integer(genreDict[topGenreTripletDF$Three[i]])), 
         size = topGenreTripletDF$Count[i])
  })
  
  
  topGenreAll <- c(topGenre, topGenrePair, topGenreTriplet)
  
  return(topGenreAll)
}



























