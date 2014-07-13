
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

books <- read.csv("Books_data.csv",sep=";",header=TRUE,as.is=c("Authors","Title"))
model=lm(Price~Pages*Cover+Pages*Publisher+Cover*Publisher,data=books)

CreatePlot <- function(pgs,ct,pub,cur,rate)
{
    data_to_predict=data.frame(Cover=ct,Pages=pgs,Publisher=pub)
    pred <- predict(model,newdata=data_to_predict,se.fit=TRUE)
    pred.plim <- predict(model, newdata=data_to_predict, interval = "prediction")
    pred.clim <- predict(model, newdata=data_to_predict, interval = "confidence")
    
    plot_title=paste(data_to_predict$Publisher,"book with",data_to_predict$Cover,
                     "and",data_to_predict$Pages,"pages",sep=" ")
    
    
    if (pred.plim[2]>=0) pred_int_lower = pred.plim[2] else pred_int_lower=0
    
    plot_data=c(pred_int_lower,pred.clim[2],pred$fit[1],pred.clim[3],pred.plim[3])
    
    text_offset=50
    if (cur=="USD") 
    {
        plot_data=plot_data/rate
        text_offset=text_offset/rate
    }
    
    boxplot(x=plot_data,
            col="orange",main=plot_title,range=0,ylab=paste("Predicted price (",cur,")"))

    p_low_text=paste("Prediction interval lower bound (",round(plot_data[1],2),cur,")")
    text(x=1,y=plot_data[1]+text_offset,p_low_text,col="darkgreen")

    c_low_text=paste("Confidence interval lower bound (",round(plot_data[2],2),cur,")")
    text(x=1,y=plot_data[2]-text_offset,c_low_text,col="orange")

    predicted_text=paste("Predicted price (",round(plot_data[3],2),cur,")")
    text(x=1,y=plot_data[3]+text_offset,predicted_text)

    c_up_text=paste("Confidence interval upper bound (",round(plot_data[4],2),cur,")")
    text(x=1,y=plot_data[4]+text_offset,c_up_text,col="orange")
    
    p_up_text=paste("Prediction interval upper bound (",round(plot_data[5],2),cur,")")
    text(x=1,y=plot_data[5]-text_offset,p_up_text,col="darkgreen")
}

shinyServer(function(input, output) {
    output$booksPlot <- renderPlot({
        CreatePlot(input$pgs,input$ct,input$pub,input$cur,input$rate)
    })
})
