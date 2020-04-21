fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Coronavirus Data -- United States"),
  
  sidebarLayout(
    sidebarPanel(
      selectizeInput("State", "State:", c("All USA" = NA, state_options)),
      selectizeInput("Admin2", "County:", ""),
      dateRangeInput("range", "Dates to graph:", min(deaths$Date), max(deaths$Date), min(deaths$Date), max(deaths$Date)),
      radioButtons("type", "Graphs to show:", c("Cases" = "cases", "Deaths" = "deaths"), "cases"),
      radioButtons("scale", "Y axis scales:", c("Linear" = "lin", "Logarithmic" = "log")),
      h5(tagList("Data sourced from", tags$a(href = "https://github.com/CSSEGISandData/COVID-19", "John Hopkins CSSE."))),
      h5(tags$a(href = "https://github.com/mikemahoney218/covid-app", "See the code."))
    ),
    mainPanel(
      plotOutput("cumu"),
      plotOutput("incr"),
      textOutput("upd")
    )
  )
)