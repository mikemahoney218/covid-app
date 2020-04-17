library(shiny)
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(ggplot2)
library(shinythemes)
deaths <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv") %>% 
  pivot_longer(cols = matches("^\\d.*"), names_to = "Date", values_to = "cumulative") %>% 
  mutate(Date = as_date(Date, format = "%m/%d/%y", tz = "America/New_York")) %>% 
  group_by(Province_State, Admin2) %>% 
  filter(max(cumulative) > 0) %>% 
  arrange(Province_State, Admin2, Date) %>% 
  mutate(daily = cumulative - lag(cumulative, 1L, 0))

cases <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv") %>% 
  pivot_longer(cols = matches("^\\d.*"), names_to = "Date", values_to = "cumulative") %>% 
  mutate(Date = as_date(Date, format = "%m/%d/%y", tz = "America/New_York")) %>% 
  group_by(Province_State, Admin2) %>% 
  filter(max(cumulative) > 0) %>% 
  arrange(Province_State, Admin2, Date) %>% 
  mutate(daily = cumulative - lag(cumulative, 1L, 0))

state_options <- unique(deaths$Province_State)

update_data <- function(category, state, a2) {
  
  if (category == "death") dat <- deaths
  if (category == "cases") dat <- cases
  
  if (is.null(state) || state == "NA") {
    
  } else if (is.null(a2) || a2 == "NA") {
    dat <- dat %>% 
      filter(Province_State == state)
  } else {
    dat <- dat %>% 
      filter(Province_State == state &
               Admin2 == a2)
  }
  
  dat %>% 
    group_by(Date) %>% 
    summarise(cumulative = sum(cumulative),
              daily = sum(daily))
}

make_graph <- function(grob, scale_func, date_range) {
  grob + 
    geom_col() +
    scale_func(expand = expansion(c(0, 0.07)),
               labels = scales::comma) +
    scale_x_date(limits = date_range) +
    ggthemes::theme_gdocs() +
    labs(y = "", x = "")
}