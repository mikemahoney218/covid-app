fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Coronavirus Data"),
  
  sidebarLayout(
    sidebarPanel(
      selectizeInput("State", "State:", c("All USA" = NA, state_options)),
      selectizeInput("Admin2", "County:", ""),
      dateRangeInput("range", "Dates to graph:", min(deaths$Date), max(deaths$Date), min(deaths$Date), max(deaths$Date)),
      radioButtons("type", "Graphs to show:", c("Cases" = "cases", "Deaths" = "death"), "cases"),
      radioButtons("scale", "Y axis scales:", c("Linear" = "lin", "Logarithmic" = "log"))
    ),
    mainPanel(
      plotOutput("cumu"),
      plotOutput("incr"),
      textOutput("upd"),
      h6(tagList("Data sourced from", tags$a(href = "https://github.com/CSSEGISandData/COVID-19", "John Hopkins CSSE.")))
    )
  )
)