library(dplyr)
library(rvest)
library(stringi)
library(readr)

movieHtml <- read_html("http://250movies.com/") %>%
  html_node("#chart") 

movies <- data_frame(
  Rank = movieHtml %>% 
    html_nodes(".rank") %>% 
    html_text() %>% 
    stri_replace_all_regex("\\..*$", "") %>% 
    as.integer(),
  Title = movieHtml %>% 
    html_nodes(".movietitle:first-child") %>%
    html_text() %>%
    stri_replace_all_regex("(\\n)|(\\t\\#*)", ""),
  Director = movieHtml %>%
    html_nodes(".additional") %>%
    html_text() %>%
    stri_replace_all_regex("(\\n|\\t)", "") %>%
    stri_replace_all_regex("(^.+Directed by\\s)|(\\sin.\\s\\d{4}.+$)", ""),
  Year = movieHtml %>%
    html_nodes(".additional>a:first-of-type") %>%
    html_text() %>%
    as.integer(),
  Genre = movieHtml %>%
    html_nodes(".additional") %>%
    html_text() %>%
    stri_replace_all_regex("(\\n|\\t)", "") %>%
    stri_replace_all_regex("(^.+Genre:.\\s)|(\\.Country.+$)", ""),
  Country = movieHtml %>%
    html_nodes(".additional") %>%
    html_text() %>%
    stri_replace_all_regex("(\\n|\\t)", "") %>%
    stri_replace_all_regex("(^.+Country:.\\s)|(\\.Rating.+$)", ""),
  Rating = movieHtml %>%
    html_nodes(".additional") %>%
    html_text() %>%
    stri_replace_all_regex("(\\n|\\t)", "") %>%
    stri_replace_all_regex("(^.+Rating:.\\s)|(\\.Votes.+$)", "") %>%
    as.numeric(),
  Votes = movieHtml %>%
    html_nodes(".additional") %>%
    html_text() %>%
    stri_replace_all_regex("(\\n|\\t)", "") %>%
    stri_replace_all_regex("(^.+Votes:.\\s)|(\\.Link to.+$)", "") %>%
    stri_replace_all_fixed(",", "") %>%
    as.numeric()
)

write_csv(movies, path = "data/movies250.csv")


















