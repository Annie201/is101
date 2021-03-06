#http://bigbigdata.tistory.com/78에 기반 했습니다.
#http://ddokbaro.com/3695에 기반 했습니다.
# Revised 12/01/2015
# 11/24/2015


library(KoNLP)
library(wordcloud)

setwe("YOUR DIRECTORY")
dh <- file('YOUR RAW DATA FILE NAME', encoding ="UTF-8")
dh.lines<-readLines(dh)
useSejongDic()
dh.nouns <- sapply(dh.lines, extractNoun, USE.NAMES=F)
dh.data <- unlist(dh.nouns)
dh.data2 <- Filter(function(x){nchar(x)>1}, dh.data)
dh.data2 <- gsub("STOPWORD", "", dh.data2) #repeatable
# Deleting NULL
dh.wordcount2 <- table(unlist(dh.data2), exclude="")
df.dh.wordcount2 <- as.data.frame(dh.wordcount2)

pal <- brewer.pal(12,"Set3")
pal <- pal[-c(1:2)]

png("YOUR WORDCLOUD FILE NAME HERE.png", width=561,height=561)
wordcloud(names(dh.wordcount2),freq=dh.wordcount2,scale=c(10,1),max.words=50,random.order=F,random.color=F, rot.per=.1,colors=pal)
dev.off()

png("YOUR HISTOGRAM FILE NAME HERE.png", width=800,height=600)
hist(dh.wordcount2, ylim=c(0,max(dh.wordcount2)), breaks=length(table(dh.wordcount2)), main="histogram of words")
dev.off()
