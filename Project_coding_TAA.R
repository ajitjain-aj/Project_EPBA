setwd("C:/Users/ajit.jain/Desktop/Project-TechnicalPortfolioPerformance")
library(pdfetch)
library(lubridate)
library(ggplot2)
library(openxlsx)
library(xts)

#----------Setting start date from where we are fetching data --------------------
startdate<-ymd(Sys.Date())-years(5)

#----------Reading the list of 101 nse stocks-------------------------------------
stock_list<-read.csv("ind_nifty500list.csv")

#----------Fetching all data of 101 stocks from Yahoo finance--------------------
for(i in 1:nrow(stock_list)){
  stock_name<-paste(stock_list[i,3],".NS",sep = "")
  stock_temp<-pdfetch_YAHOO(stock_name,fields = c("adjclose"),from = startdate,to = Sys.Date(),interval = '1mo')
  colnames(stock_temp)<- stock_list[i,3]
  colnames(stock_temp)
  if(i==1){
    stock_data<-stock_temp
  }
  else{
    stock_data<-cbind(stock_data,stock_temp)
  }
}

#----------Deducing correlation of 501 stocks(to be used while applying asset weight allocation) ------------
cor_comp<-cor(stock_data,use = 'complete')


#---------- pulling data out to excel to check manually -------------

stock_data_index<-format(as.data.frame(index(stock_data)),"%d/%m/%Y")
colnames(stock_data_index)<-"Date"
stock_data_df<-cbind(stock_data_index,as.data.frame(stock_data))
write.xlsx(stock_data_df, "stock_data_df.xlsx")

#-----------

