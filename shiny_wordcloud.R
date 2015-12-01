# 두번째 과제 용입니다.
#http://bigbigdata.tistory.com/78에 기반 했습니다.
#http://ddokbaro.com/3695에 기반 했습니다.
# Revised 12/01/2015
# 11/27/2015
#Based on shiny gallery wordcloud script

library(KoNLP)
library(wordcloud)
library(shiny)


dh <- file('YOUR RAW DATA FILE NAME', encoding ="UTF-8")
dh.lines<-readLines(dh)
useSejongDic()
dh.nouns <- sapply(dh.lines, extractNoun, USE.NAMES=F)
dh.data <- unlist(dh.nouns)
dh.data2 <- Filter(function(x){nchar(x)>1}, dh.data)
dh.data2 <- gsub("STOPWORD", "", dh.data2) # Repeatable
dh.wordcount2 <- table(unlist(dh.data2), exclude="") # excluding NULL char
write.table(dh.wordcount2, "dh.wordcount2.txt", sep="\t", row.names=FALSE)

#Romanizing in HANGEUL 

#read romanized words
dh_rom <- read.table('rm_dh.wordcount2.txt', encoding="UTF-8", header=T)
dh.wordcount3 <- as.data.frame(dh_rom)

#wordclouding
pal <- brewer.pal(12,"Set3")
pal <- pal[-c(1:2)]
wordcloud(dh.wordcount3$Var1,freq=dh.wordcount3$Freq,scale=c(10,1),max.words=50,random.order=F,random.color=F, rot.per=.1,colors=pal)

kwd.freq <- dh.wordcount3$Freq
kwd.names <-dh.wordcount3$Var1
#### Server ####
server <- function(input, output) {
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    
    wordcloud_rep(kwd.names, kwd.freq, scale=c(10,1),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
  
}

#### UI ####

ui <- shinyUI(fluidPage(
  
  titlePanel("My wordcloud"),
  
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("freq","Minimum Frequency in Wordcloud:",min = min(kwd.freq),  max = max(kwd.freq), value = 2),
      sliderInput("max","Maximum Number of Words in Wordcloud:", min = 1,  max = length(kwd.names),  value = 100)
      
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
