# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observe({
    
    county_filtering <- unique(deaths[deaths$Province_State == input$State, ]$Admin2)
    
    # Can also set the label and select items
    updateSelectizeInput(session, "Admin2",
                      choices = c("All Counties" = NA, county_filtering)
    )
    
    country_filtering <- unique(global_deaths[global_deaths$`Country/Region` == input$gb_country, ]$`Province/State`)
    
    # Can also set the label and select items
    updateSelectizeInput(session, "gb_region",
                         choices = c("All Regions" = NA, country_filtering)
    )
    
  })

  data_filter <- reactive({
    update_data(input$type, input$State, input$Admin2, input$days_inc)
  })
  
  gb_data_filter <- reactive({
    update_global_data(input$gb_type, input$gb_country, input$gb_region, input$gb_days_inc)
  })
  
  output$cumu <- renderPlot({
    
    if (input$scale == "lin") {
      scale_func <- scale_y_continuous
    } else {
      scale_func <- scale_y_log10
    }
    
    if (input$State == "NA") {
      title_string <- paste0(input$type, " - United States")
    } else if (input$Admin2 == "NA") {
      title_string <- paste0(input$type, " - ", input$State)
      
    } else {
      title_string <- paste0(input$type, " - ", input$State, ": ", input$Admin2)
    }
    
    data_filter() %>% 
      ggplot(aes(Date, cumulative)) %>% 
      make_graph(scale_func, c(input$range[[1]] - days(1), input$range[[2]] + days(1))) + 
      ggtitle(paste0("Cumulative ", title_string))
    
    })
  
  output$incr <- renderPlot({
    if (input$scale == "lin") {
      scale_func <- scale_y_continuous
    } else {
      scale_func <- scale_y_log10
    }
    
    if (input$State == "NA") {
      title_string <- paste0(input$type, " - United States")
    } else if (input$Admin2 == "NA") {
      title_string <- paste0(input$type, " - ", input$State)
      
    } else {
      title_string <- paste0(input$type, " - ", input$State, ": ", input$Admin2)
    }
    
    data_filter() %>% 
      ggplot(aes(Date, daily)) %>% 
      make_graph(scale_func, c(input$range[[1]] - days(1), input$range[[2]] + days(1))) +
      geom_line(aes(y = avg), size = 1.3, color = "blue") +
      ggtitle(paste0("Daily ", title_string))
  })
  
  output$upd <- renderText({
    paste("Data extends until", format(max(c(deaths$Date, cases$Date)), "%A, %B %d, %Y"))
  })

  output$sources <- renderText({
      'Data sourced from <a href="https://github.com/CSSEGISandData/COVID-19">John Hopkins CSSE</a>.'
  })
  
  ###############
  output$gb_cumu <- renderPlot({
    
    if (input$gb_scale == "lin") {
      scale_func <- scale_y_continuous
    } else {
      scale_func <- scale_y_log10
    }
    
    if (input$gb_country == "NA") {
      title_string <- paste0(input$gb_type, " - Worldwide")
    } else if (input$gb_region == "NA") {
      title_string <- paste0(input$gb_type, " - ", input$gb_country)
      
    } else {
      title_string <- paste0(input$gb_type, " - ", input$gb_country, ": ", input$gb_region)
    }
    
    gb_data_filter() %>% 
      ggplot(aes(Date, cumulative)) %>% 
      make_graph(scale_func, c(input$gb_range[[1]] - days(1), input$gb_range[[2]] + days(1))) + 
      ggtitle(paste0("Cumulative ", title_string))
    
  })
  
  output$gb_incr <- renderPlot({
    if (input$gb_scale == "lin") {
      scale_func <- scale_y_continuous
    } else {
      scale_func <- scale_y_log10
    }
    
    if (input$gb_country == "NA") {
      title_string <- paste0(input$gb_type, " - Worldwide")
    } else if (input$gb_region == "NA") {
      title_string <- paste0(input$gb_type, " - ", input$gb_country)
      
    } else {
      title_string <- paste0(input$gb_type, " - ", input$gb_country, ": ", input$gb_region)
    }
    
    gb_data_filter() %>% 
      ggplot(aes(Date, daily)) %>% 
      make_graph(scale_func, c(input$gb_range[[1]] - days(1), input$gb_range[[2]] + days(1))) +
      geom_line(aes(y = avg), size = 1.3, color = "blue") +
      ggtitle(paste0("Daily ", title_string))
  })
  
  output$gb_upd <- renderText({
    paste("Data extends until", format(max(c(global_deaths$Date, global_deaths$Date)), "%A, %B %d, %Y"))
  })
  
}

