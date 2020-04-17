# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observe({
    
    county_filtering <- unique(deaths[deaths$Province_State == input$State, ]$Admin2)
    
    # Can also set the label and select items
    updateSelectizeInput(session, "Admin2",
                      choices = c("All Counties" = NA, county_filtering)
    )
  })

  data_filter <- reactive({
    update_data(input$type, input$State, input$Admin2)
  })
  
  output$cumu <- renderPlot({
    
    if (input$scale == "lin") {
      scale_func <- scale_y_continuous
    } else {
      scale_func <- scale_y_log10
    }
    
    data_filter() %>% 
      ggplot(aes(Date, cumulative)) %>% 
      make_graph(scale_func, c(input$range[[1]], input$range[[2]])) + 
      ggtitle("Cumulative numbers")
    
    })
  
  output$incr <- renderPlot({
    if (input$scale == "lin") {
      scale_func <- scale_y_continuous
    } else {
      scale_func <- scale_y_log10
    }
    
    data_filter() %>% 
      ggplot(aes(Date, daily)) %>% 
      make_graph(scale_func, c(input$range[[1]], input$range[[2]])) +
      ggtitle("Daily increases")
  })
  
  output$upd <- renderText({
    paste("Data last updated on", format(max(c(deaths$Date, cases$Date)), "%A, %B %d, %Y"))
  })
}

