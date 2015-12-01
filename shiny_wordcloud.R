#Version 0.5 두번째 과제 용입니다.
#http://bigbigdata.tistory.com/78에 기반 했습니다.
#http://ddokbaro.com/3695에 기반 했습니다.
# 11/27/2015
#Based on shiny wordcloud script

library(KoNLP)
library(wordcloud)
library(shiny)


dh <- file('YOUR RAW DATA FILE NAME', encoding ="UTF-8")
dh.lines<-readLines(dh)
useSejongDic()
dh.nouns <- sapply(dh.lines, extractNoun, USE.NAMES=F)
dh.data <- unlist(dh.nouns)
dh.data2 <- Filter(function(x){nchar(x)>MINIMUM LENGTH OF WORD HERE}, dh.data)
dh.data2 <- gsub("STOPWORD", "", dh.data2)
dh.wordcount2 <- table(unlist(dh.data2), exclude="")
write.table(dh.wordcount2, "dh.wordcount2.txt", sep="\t", row.names=FALSE)

#Romanizing in HANGEUL 

#read romanized words
dh_rom <- read.table('dh.wordcount2.txt', encoding="UTF-8", header=T)
dh.wordcount3 <- as.data.frame(dh_rom)


#### Server ####
server <- function(input, output) {
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    
    wordcloud_rep(dh_rom$dh_rlines, dh_rom$Freq, scale=c(4,0.2),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(11, "Spectral"))
  })
  
}

#### UI ####

ui <- shinyUI(fluidPage(
  
  titlePanel("My wordcloud"),
  
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("freq","Minimum Frequency in Wordcloud:",min = min(dh_rom$Freq),  max = max(dh_rom$Freq), value = 15),
      sliderInput("max","Maximum Number of Words in Wordcloud:", min = 1,  max = length(dh_rom$dh_rlines),  value = 100)
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Open data records", plotOutput("plot"))
        
      )
    )
  )
))

#### Run ####
shinyApp(ui = ui, server = server)
