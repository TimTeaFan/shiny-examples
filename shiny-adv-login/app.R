# Advanced shiny login example

library("shiny")
library("shinyjs")
library("stringr")
library("bcrypt")

# // This recieves messages of type "testmessage" from the server.
# Shiny.addCustomMessageHandler("testmessage",
#                               function(message) {
#                                   alert(JSON.stringify(message));
#                               }
# );

shinyApp(
  
  ui = fluidPage(
    
    useShinyjs(),  # Set up shinyjs
    shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),

    # Layout mit Sidebar
    sidebarLayout(
      
      ## Sidebar -----
      shinyjs::hidden(
        div(id = "Sidebar", sidebarPanel(
          
          # > some example input on sidebar -----
          actionButton("refresh", "Logout"),
          br(),
          
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
                            tags$a(href="shiny.rstudio.com/tutorial", "View code on GitHub")
                   )
                   
          ), # closes tabPanel
          
          id = "tabselected", type = "pills"
          
        )  # closes tabsetPanel      
        
      )  # closes mainPanel                      
      
    ) # closes sidebarLayout
    
  ), # closes fluidPage
  
  
  # Server ------
  server = function(input, output, session){
    
    user <- reactiveValues(his = readRDS(file = "logs/user_his.rds"),
                           log = readRDS(file = "logs/user_log.rds"),
                           dat = readRDS(file = "logs/user_dat.rds"))


    
    
    observeEvent(input$login, {
      
      # is username in user_dat and has less than three login attempts?
      if (str_to_lower(input$username) %in% names(user$dat[user$his < 3])) {  
        
        # 
        if (input$password == unname(user_vec[str_to_lower(input$username)])) {
          
          # nulls the user_his login attempts and saves this on server
          user$his[str_to_lower(input$username)] <- 0
          saveRDS(user$his, file = "logs/user_his.rds")
          
          # saves a temp log file
          user_log_temp <- data.frame(username = str_to_lower(input$username),
                                     timestamp = Sys.time())
          
          # saves temp log in reactive value
          user$log <- rbind(user$log, user_log_temp)
          
          # saves reactive value on server
          saveRDS(user$log, file = "logs/user_log.rds")
          

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
        
      } else { #username name wrong 
        
        # specify if needed
        
      } # closes second if-clause
      
    }) # closes observeEvent
    
    
    # observeEvent(input$refresh, {
    #   shinyjs::js$refresh()
    # })
    
    
    
  } # Closes server
) # Closes ShinyApp