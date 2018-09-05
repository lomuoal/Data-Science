#juntar todos y lo guardamos en una variable
all.train<-load_data('/Users/Lorena/Desktop/Sesion Practica',1:10,7:8)
#pasarlo a dataframe
df_train<- do.call('rbind',lapply(all.train,as.data.frame))
#guardarlo en csv
write.csv(df_train,file="all_data.csv", row.names =T)

#test
df_test<-read.csv('Ficheros_proyecto_DS/test/random_samples_N100.csv',header=T)

#la mas cercana estacion = 9, modelo de perfil full
#full_profile_3h_diff_bikes
df_station9<-read.csv('Ficheros_proyecto_DS/train/station_9_train.csv',header=T)
train_9<-na.omit(df_station9)


#validacion cruzada
train_control<-trainControl(method = "cv", number = 10)

#Regresion lineal
model.lm<-train(bikes~short_profile_3h_diff_bikes+short_profile_bikes+bikes_3h_ago+temperature.C,data=train_9,trControl=train_control,method="lm",na.rm=T) 
print(model.lm)


df_deploy_8<-read.csv('Ficheros_proyecto_DS/deploy/station_8_deploy.csv',header=T)

#prediccion
prediccion<-predict(model.lm,df_deploy_8)
prediccion
prediccion[prediccion<0]<-0

max<-df_deploy_8[1,"numDocks"]
prediccion[prediccion>max]<-max
library(hydroGOF)
mae(prediccion,df_deploy_8$bikes)

#test
test<-round(predict(model.lm,df_test))
test[test<0]<-0
test[test>max]<-max



submision1<-df_test[,c("station","timestamp")]
resultado<-cbind(submision1,test)
write.csv(resultado,file='example_submission1.csv')

