## Libraries
library(raster)
library(sp)
library(sf)
library(rgdal)
library(tidyverse)
library(ggmap)
library(rasterVis)
library(maptools)
library(mosaic)
library(rgeos)
library(velox)
library(lubridate)
library(writexl)


### Escoger shape
shp1 <- readOGR(file.choose())

shp2 <- readOGR(file.choose())

shpcr <- rbind(shp1, shp2)


### poner los raster en una lista
files <- list.files(pattern =".tif$")


### transformar a raster
rstrs <- lapply(files,  FUN = function(x) { raster::raster(x) })


### Cortar rasters para una nueva lista
e <- extent(-130, -60, -5, 35)

beginCluster(n =4)
nuevalista <- lapply(rstrs, FUN = function(x) { crop(x,e) })
endCluster()


### Rutina para generar una base completa
datalist <- list()

  for (i in 1:length(rstrs)) {
    beginCluster(n = 4)
  f <- raster::extract(rstrs[[i]], shpcr)
  endCluster()
  
  shtb <- as.tibble(shpcr)
  
  muni <- lapply(f, FUN = function(x) { fav_stats(x) })
  
  base <- rbind_list(muni)
  
  dat <- base %>%
    mutate(mes = paste0(month.abb[i]))%>%
    mutate_if(is.factor, as.character)
  
  dat <- as.tibble(cbind(dat, shtb))
  
  datalist[[i]] <- dat  
  }

base <- do.call(rbind, datalist)

writexl::write_xlsx(base, "guate_salv.xlsx")




