# Advanced shiny login example

library("shiny")
library("shinyjs")
library("stringr")
library("bcrypt")
library("ggplot2")
library("V8")

shinyApp(
  
  ui = fluidPage(
    
    # Set up shinyjs
    useShinyjs(), 
    
    # javascript refresh function for logout button
    shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"), 
    
    # Layout wtih sidebar
    sidebarLayout(
      
      ## Sidebar -----
      shinyjs::hidden( # hide sidebar on login tab
        
        div(id = "Sidebar", sidebarPanel(
          
          # > some example input on sidebar -----
          # actionButton("refresh", "Logout"),
          br(),
          
          conditionalPanel(
            condition = "input.tabselected == 4",
            sliderInput(inputId = "bins",
                        label = "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
            
          ),
          
          uiOutput("UI_input")
          
          
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
                   tags$head(tags$script(src = "message-handler.js"),
                             tags$script(src = "login-button.js")),
                   actionButton("login", "login"),
                   br(),
                   br(),
                   tags$div(class="header", checked = NA,
                            tags$p("This app shows a shiny login workaround with several additional features."),
                            tags$p("Shiny server pro is not necessary for any of the features presented in this app."),
                            tags$p("The following username/password combinations can be used:"),
                            tags$p("user: 'worker' // pass: 'workerlogin'"),
                            tags$p("user: 'boss'   // pass: 'bosslogin'."),
                            tags$a(href="https://github.com/TimTeaFan/shiny-examples/tree/master/shiny-adv-login",
                                   "View code on GitHub")
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
      if (str_to_lower(input$username) %in% user$dat$user[user$his < 3]) { # 
        
        # does password match?
        if (checkpw(input$password, user$dat[user$dat$user == str_to_lower(input$username), ]$pass)) {
        # if (input$password == unname(user$dat$pass[str_to_lower(input$username)])) {
          
          # nulls login attempts in user_his and saves this on server
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
                    
                    tabPanel("Welcome tab",
                             value = 2,
                             br(),
                             tags$div(class = "body", checked = NA,
                                      tags$p(paste("Congratulations! You successfully logged in as '", input$username, "'.")),
                                      tags$p("Have a look around and then login as a different user.")
                             )
                             
                    ) # closes tabPanel,
                    
          )
          
          # add a tab which can only accessed by certain users ("managers" in this example)
          if (user$dat[user$dat$user == input$username, ]$access == "manager") {
            
            appendTab(inputId = "tabselected",
                    
                    tabPanel("Manager tab",
                             value = 3,
                             
                             br(),
                             br(),
                             
                             tags$div(class="header", checked = NA,
                                      tags$p("This panel can only be viewed by users with access to domain 'manager'."),
                                      tags$p("When you login as 'worker' this panel will not be visible to you.")
                             )
                             
                    ) # closes tabPanel,
          )}
          
          # tab which contains plot 
          appendTab(inputId = "tabselected",
                    
                    tabPanel("Plot tab",
                             
                             value = 4,
                             
                             plotOutput(outputId = "distPlot"),
                             fluidRow(
                               downloadButton('downloadPlot_water', 'Download Plot'),
                               align = "right", offset = 10, style = 'padding:0px;'
                             )
                             
                    ) # closes tabPanel         
          )
          
          # Last tab is used as an action button to reload the app, and thereby force the user to logout
          appendTab(inputId = "tabselected",
                    
                    tabPanel("Logout",
                             
                             value = 5
                             
                    ) # closes tabPanel         
          )
          
          removeTab(inputId = "tabselected",
                    target = "1")
          
        } else { # username correct, password wrong
          
          # adds a login attempt to user_his 
          user$his[str_to_lower(input$username)] <- user$his[str_to_lower(input$username)] + 1

          # saves user_his on server
          saveRDS(user$his, file = "logs/user_his.rds")
          
          # Messge which shows how many log-in tries are left
          session$sendCustomMessage(type = 'loginmessage',
                                    message = paste0('Password not correct. ',
                                                     'Remaining log-in attempts: ',
                                                     3 - user$his[str_to_lower(input$username)]
                                    )
          )
     
        } # closes if-clause
        
      } else { #username wrong 
        
        # Send error messages with javascript message handler

        session$sendCustomMessage(type = 'loginmessage',
                                  message = paste0('Wrong username or user blocked.')
        )
        
        
      } # closes second if-clause
      
    }) # closes observeEvent
    
    # 
    observe({input$tabselected
          if (input$tabselected == 5) {
            shinyjs::js$refresh()
          }
    })
    
    # render UI input based on access rights  
    output$UI_input <- renderUI({
          
          # condition which checks the users access rights as specified in logs/user_dat.rds
          if ((user$dat[user$dat$user == input$username, ]$access == "manager") && input$tabselected == 3) { #  
            
          selectInput("region", "Select region: (only available for managers)",
                      list("East", "West", "South", "North"))
          }

    })
    
    # Plot ------
    # reactive input that can be used for download hanlder
    plotInput <- reactive({
      
      p <- ggplot(faithful, aes(x = waiting)) +
        geom_histogram(bins = input$bins) +
        xlab("Waiting time to next eruption (in mins)") +
        ggtitle("Histogram of waiting times")
      
      print(p)
      
    })
    
    # plot output 
    output$distPlot <- renderPlot({
    
      print(plotInput())
      
    })
    
    # Download plot -------
    # this downdload handler not only enables users to download the respective plot, but it will
    # also save a copy in the server log files
    
    # download handler flag
    rv <- reactiveValues(download_flag = 0)
    
    # download handler
    output$downloadPlot <- downloadHandler(

      filename = function() { paste0("logs/plots/", gsub("-|\\:| ", "", as.Date(Sys.time())), "bins_nr_", input$bins,".png") },

      content = function(file) {
        ggsave(file, plot = plotInput(), device = "png")
        rv$download_flag <- rv$download_flag + 1

      }
    )
      
    # observe for ggsave
    observeEvent(rv$download_flag, {
        
    ggsave(paste0("logs/plots/", input$username, gsub("-|\\:| ", "", as.Date(Sys.time())), "bins_nr_", input$bins,".png"),
               plot = plotInput(),
               device = "png")
      }, ignoreInit = TRUE)
    
    
    
    
    
  } # Closes server
) # Closes ShinyApp