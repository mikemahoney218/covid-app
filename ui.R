navbarPage(
  "Coronavirus Data",
  theme = shinytheme("flatly"),
  tabPanel(
    "United States",
    sidebarLayout(
      sidebarPanel(
        selectizeInput("State", "State:", c("All USA" = NA, state_options)),
        selectizeInput("Admin2", "County:", ""),
        dateRangeInput("range", "Dates to graph:", min(deaths$Date), max(deaths$Date), min(deaths$Date), max(deaths$Date)),
        numericInput("days_inc", "# days to include in moving average:", 7, 1, step = 1),
        radioButtons("type", "Graphs to show:", c("Cases" = "cases", "Deaths" = "deaths"), "cases"),
        radioButtons("scale", "Y axis scales:", c("Linear" = "lin", "Logarithmic" = "log")),
        h5("Bars represent value for that day. Blue line represents moving average."),
        h5(tagList("Data sourced from", tags$a(href = "https://github.com/CSSEGISandData/COVID-19", "John Hopkins CSSE."))),
        h5(tags$a(href = "https://github.com/mikemahoney218/covid-app", "See the code."))
      ),
      mainPanel(
        plotOutput("cumu"),
        plotOutput("incr"),
        textOutput("upd")
      )
    )
  ),
  tabPanel(
    "World",
    sidebarLayout(
      sidebarPanel(
        selectizeInput("gb_country", "Country:", c("Worldwide" = NA, country_options)),
        selectizeInput("gb_region", "Region:", ""),
        dateRangeInput("gb_range", "Dates to graph:", min(global_deaths$Date), max(global_deaths$Date), min(global_deaths$Date), max(global_deaths$Date)),
        numericInput("gb_days_inc", "# days to include in moving average:", 7, 1, step = 1),
        radioButtons("gb_type", "Graphs to show:", c("Cases" = "cases", "Deaths" = "deaths"), "cases"),
        radioButtons("gb_scale", "Y axis scales:", c("Linear" = "lin", "Logarithmic" = "log")),
        h5("Bars represent value for that day. Blue line represents moving average."),
        h5(tagList("Data sourced from", tags$a(href = "https://github.com/CSSEGISandData/COVID-19", "John Hopkins CSSE."))),
        h5(tags$a(href = "https://github.com/mikemahoney218/covid-app", "See the code."))
      ),
      mainPanel(
        plotOutput("gb_cumu"),
        plotOutput("gb_incr"),
        textOutput("gb_upd")
      )
    )
  )
)
