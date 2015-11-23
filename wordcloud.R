#http://bigbigdata.tistory.com/78에 기반했습니다.
library(KoNLP)
library(wordcloud)
dh <- file('YOUR FILE HERE', encoding ="UTF-8")
dh.lines<-readLines(dh)
useSejongDic()
dh.nouns <- sapply(dh.lines, extractNoun, USE.NAMES=F)
dh.data <- unlist(dh.nouns)
dh.data2 <- Filter(function(x){nchar(x)>MINIMUM LENGTH OF WORD HERE}, dh.data)
dh.wordcount2 <- table(unlist(dh.data2))
df.dh.wordcount2 <- as.data.frame(dh.wordcount2)

