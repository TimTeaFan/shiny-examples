#

library("shiny")
library("shinyjs")
library("stringr")


shinyApp(
  
  ui = fluidPage(
    
    useShinyjs(),  # Set up shinyjs
  
    # Layout mit Sidebar
    sidebarLayout(
      
      ## Sidebar -----
      shinyjs::hidden(
        div(id = "Sidebar", sidebarPanel(
          
          # > some example input on sidebar -----
          
          conditionalPanel(
            condition = "input.tabselected > 1",
            dateRangeInput(inputId = "date",
                           label = "Choose date range",
                           start = "2018-06-25", end = "2019-01-01",
                           min = "2018-06-25", max = "2019-01-01",
                           startview = "year")) 
          
           ) # closes Sidebar-Panel
          ) # closes div
        ), # closes hidden()
      
      # Main-Panel ------
      mainPanel(
        br(),
        tabsetPanel(
          
          # > Login -------

          tabPanel("Login tab",
                   value = 1,
                   br(),
                   textInput("username", "username"),
                   passwordInput("password", label = "password"),
                   actionButton("login", "login"),
                   br(),
                   br(),
                   tags$div(class="header", checked = NA,
                            tags$p("This is a simple shiny login workaround without using shiny server pro."),
                            tags$p("Try username 'user123' and password 'password1'."),
                            tags$a(href="https://github.com/TimTeaFan/shiny-examples/tree/master/shiny-simple-login", "View code on GitHub")
                   )
                   
          ), # closes tabPanel
          
          id = "tabselected", type = "pills"
          
        )  # closes tabsetPanel      
        
      )  # closes mainPanel                      
      
    ) # closes sidebarLayout
    
  ), # closes fluidPage
  
  
  # Server ------
  server = function(input, output, session){
    
    user_vec <- c("user123" = "password1",
                  "user456" = "password2")
    
    observeEvent(input$login, {
      
      if (str_to_lower(input$username) %in% names(user_vec)) { # is username in user_vec?
        
        if (input$password == unname(user_vec[str_to_lower(input$username)])) {

          # > Add MainPanel and Sidebar----------
          shinyjs::show(id = "Sidebar")
          
          appendTab(inputId = "tabselected",
                    
                    tabPanel("Tab 1",
                             value = 2,
                             br(),
                             tags$div(class="body", checked = NA,
                                      tags$p("Congratulations! You successfully logged in."),
                                      tags$a(href = "shiny.rstudio.com/tutorial", "Here you can find a more fleshed out example combining several features.")
                             )
                             
                    ) # closes tabPanel,
                    
          )
          
          appendTab(inputId = "tabselected",
                    
                    tabPanel("Tab 2",
                             value = 3
                             
                    ) # closes tabPanel,
          )
          
          appendTab(inputId = "tabselected",
                    
                    tabPanel("Tab 3",
                             
                             value = 4
                             
                    ) # closes tabPanel         
          )
          
          removeTab(inputId = "tabselected",
                    target = "1")
          
        } else { # username correct, password wrong
          
          # specify if needed
     
        } # closes if-clause
        
      } else { # username name wrong 
        
        # specify if needed
        
      } # closes second if-clause
      
    }) # closes observeEvent
    
    
    # observeEvent(input$refresh, {
    #   shinyjs::js$refresh()
    # })
    
    
    
  } # Closes server
) # Closes ShinyApp