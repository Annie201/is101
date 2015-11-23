#http://bigbigdata.tistory.com/78에 기반 했습니다.
#http://ddokbaro.com/3695에 기반 했습니다.

library(KoNLP)
library(wordcloud)
dh <- file('YOUR FILE HERE', encoding ="UTF-8")
dh.lines<-readLines(dh)
useSejongDic()
dh.nouns <- sapply(dh.lines, extractNoun, USE.NAMES=F)
dh.data <- unlist(dh.nouns)
dh.data2 <- Filter(function(x){nchar(x)>MINIMUM LENGTH OF WORD HERE}, dh.data)
dh.data2 <- gsub("STOPWORD", "", dh.data2)
dh.wordcount2 <- table(unlist(dh.data2))
df.dh.wordcount2 <- as.data.frame(dh.wordcount2)

pal <- brewer.pal(12,"Set3")
pal <- pal[-c(1:2)]

png("YOUR FILE NAME HERE.png", width=561,height=561)
wordcloud(names(dh.wordcount2),freq=dh.wordcount2,scale=c(10,1),max.words=50,random.order=F,random.color=F, rot.per=.1,colors=pal)
dev.off()

