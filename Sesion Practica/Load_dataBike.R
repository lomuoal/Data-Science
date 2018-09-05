directory <- '/Users/Lorena/Desktop/Sesion Practica/train'
load_data <- function(directory,id=1:200,tid=1:200) {
  #Parameters: the directory with the folder containing the files
  #whose names should end in a number
  #the range of files to be load
  
  "%ni%" <- Negate("%in%")
  
  #Output: a dataframe 
  data <- list();
  
  for (i in id) {
    if (i %in% tid) {data[[i]]<-NULL}
      else {name<-paste(directory,"/Ficheros_proyecto_DS/train/station_",as.character(i),"_train",".csv",sep="");
             data[[i]] <- read.csv(name, comment.char = "", header=T);}
  }
  return(data)
}

all.train<-load_data('/Users/Lorena/Desktop/Sesion Practica/train',1:10,7:8)

write.csv(all.train,"all_train.csv")
cat(sapply(all.train, toString), '/Users/Lorena/Desktop/all_train.txt', sep="\n")
df<- do.call('rbind',lapply(all.train,as.data.frame))
write.csv(df,file="all_data.csv")
