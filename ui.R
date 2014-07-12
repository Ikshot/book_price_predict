
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Book price prediction"),
  
  # Sidebar with a slider input for pages in the book
  sidebarPanel(
    sliderInput("pgs", 
                "Number of pages:", 
                min = 1, 
                max = 3000, 
                value = 300),
    selectInput("ct", "Cover type:",
                list("Hardcover","Paperback")),
    selectInput("pub", "Publisher:",
                list("FOREIGN","RUSSIAN"))
  ),
  
  mainPanel(
      h2("Summary"),
      p("This is somehow made up, but useful app (for me at least)."),
      p("I've got many books through the years and i've got catalog of them 
        which includes authors, titles, prices, numbers of pages, etc. Let's 
        imagine that i want book on some topic and i want to predict how much it will 
        cost me using the accumulated info. For example, foreign books are higher in price 
        because of packaging and transportation costs. Quick references on topics have less 
        pages then books with deep coverage of those topics. Hardcovered books costs higher 
        then paperbacks and so on."),
      p("Based on books dataset with 481 observations the app builds linear regression model 
        with ", strong("Price")," as dependent variable and ",strong("Publisher (Russian or Foreign), 
        Type of cover and Number of pages")," as predictors."),
      p("Because i am in Russia, costs given in rubles (RUR) - our currency."),
      p("Have fun! :)"),
      h2("Result"),
      plotOutput("booksPlot",width="60%")
  )
))
