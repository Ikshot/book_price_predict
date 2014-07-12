
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

books <- read.csv("Books_data.csv",sep=";",header=TRUE,as.is=c("Authors","Title"))
model=lm(Price~Pages*Cover+Pages*Publisher+Cover*Publisher,data=books)

CreatePlot <- function(pgs,ct,pub)
{
    data_to_predict=data.frame(Cover=ct,Pages=pgs,Publisher=pub)
    pred <- predict(model,newdata=data_to_predict,se.fit=TRUE)
    pred.plim <- predict(model, newdata=data_to_predict, interval = "prediction")
    pred.clim <- predict(model, newdata=data_to_predict, interval = "confidence")
    
    plot_title=paste(data_to_predict$Publisher,"book with",data_to_predict$Cover,
                     "and",data_to_predict$Pages,"pages",sep=" ")
    
    if (pred.plim[2]>=0) pred_int_lower = pred.plim[2] else pred_int_lower=0
    
    boxplot(x=c(pred_int_lower,pred.clim[2],pred$fit[1],pred.clim[3],pred.plim[3]),
            col="orange",main=plot_title,range=0,ylab="Predicted price (RUR)")
    
    c_up_text=paste("Confidence interval upper bound (",round(pred.clim[3],2),"RUR )")
    text(x=1,y=pred.clim[3]+50,c_up_text,col="orange")
    
    c_low_text=paste("Confidence interval lower bound (",round(pred.clim[2],2),"RUR )")
    text(x=1,y=pred.clim[2]-50,c_low_text,col="orange")
    
    p_up_text=paste("Prediction interval upper bound (",round(pred.plim[3],2),"RUR )")
    text(x=1,y=pred.plim[3]-50,p_up_text,col="darkgreen")
    
    p_low_text=paste("Prediction interval lower bound (",round(pred_int_lower,2),"RUR )")
    text(x=1,y=pred_int_lower+50,p_low_text,col="darkgreen")
    
    predicted_text=paste("Predicted price (",round(pred$fit[1],2),"RUR )")
    text(x=1,y=pred$fit[1]+50,predicted_text)
}

shinyServer(function(input, output) {
    output$booksPlot <- renderPlot({
        CreatePlot(input$pgs,input$ct,input$pub)
    })
})
