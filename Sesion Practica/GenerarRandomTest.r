#############################################################
# This code has been developed by
#   ADOLFO MARTINEZ-USO, UNIVERSITAT POLITECNICA DE VALENCIA, SPAIN
#   auso@uji.es
#
# COPYRIGHT:
#   Any use of this software (even non-profit, academic uses) *should* be done only after contacting the authors first. 
#   We will most probably grant permission to use it freely (and point to newer versions if there are). 
#############################################################


# List of packages for session
.packages = c("reshape2", "pmml", "XML", "data.table")

# Install required CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])

# Load packages into session 
lapply(.packages, require, character.only=TRUE)



dirpaste = function(...) paste(...,sep="/")
str2vec = function(s,split=",") unlist(strsplit(s,split=split))


################################################################
# Get N random and non-consecutive samples from the D_DIR path #
################################################################
GetRandomSamples <- function(N, def_station=0) {
  #Ex: >> GetRandomSamples(200)
  #Ex: >> GetRandomSamples(200, 4) #Always takes samples from station 4
  #Random seed set using time epoch
  as.numeric(Sys.time())-> t
  set.seed((t - floor(t)) * 1e8 -> seed)
  #print(seed)
  
  if (def_station==0) {
    #Select stations from 75 new ones [201..275]
    station_ord <- sample(7:8, N, replace=TRUE) #Stations can be repeated
  } else {
    #Always the same station (def_station)
    station_ord <- rep(as.integer(def_station), N)
  }
  
  DF<-NULL #Initialise data frame
  
  for (j in 1:N) {
    station = sprintf("station_%d_test_completo.csv",station_ord[j])
    #cat(paste("Station",j,":",station,"\n"))
    
    d <- read.csv(station)
    d <- na.omit(d) #We do not want missing data in or selected samples
    s <- sample(1:nrow(d),1)
    
    DF <- rbind(DF,d[s,])
  }

  filename <- sprintf("random_samples_N%03d_GT.csv", N)
  write.csv(DF, file=filename, row.names=FALSE)
  
  DF$bikes<-NULL #Remove tarjet attribute
  filename <- sprintf("random_samples_N%03d.csv", N)
  write.csv(DF, file=filename, row.names=FALSE)
  cat("\nOK.\n")
  
  DF
}

