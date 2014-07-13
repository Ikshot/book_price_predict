
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
    sliderInput("pgs","Number of pages:",min=1,max=3000,value=300),
    selectInput("ct", "Cover type:",list("Hardcover","Paperback")),
    selectInput("pub", "Publisher:",list("FOREIGN","RUSSIAN")),
    selectInput("cur", "Currency:",list("USD","RUR")),
    numericInput("rate", "1 USD = ? RUR", value=33, min = 1, max = NA, step = 0.1)
  ),
  
  mainPanel(
      h2("Summary"),
      p("This is somehow made up, but useful app (for me at least)."),
      p("I've got many books through the years and I've created a catalog of them 
        which include authors, title, price, number of pages, etc, for each book. Let's 
        imagine that I want to buy a book on some topic. I have general sense about what kind 
        of book it should be, and using the accumulated info I want 
        to predict how much such a book will cost me. For example:"),
      tags$ul(tags$li("foreign books are higher in price due to packaging and 
                transportation costs and currency conversion;"),
              tags$li("quick references on topics have less pages and lower price 
                then books with deep coverage of those topics;"), 
              tags$li("hardcovered books generally costs higher then paperbacks and so on.")),
      p("Based on my books dataset with",strong("481"),"observations the app builds linear regression model 
        with", strong("Price"),"as dependent variable and",strong("Publisher (Russian or Foreign), 
        Type of cover"),"and",strong("Number of pages"),"as predictors."),
      p("Because I am in Russia, I've got initial costs (in my dataset) in rubles ",strong("(RUR)"),"- 
        our currency. Those are converted to",strong("USD"),"if necessary."),
      p("Lower bound for price is set to",strong("0,"),"because price cannot be negative."),
      p("Have fun! :)"),
      h2("Results"),
      plotOutput("booksPlot",width="60%")
  )
))
