##################Funciones de analisis GIS#######################

####Paquetes
library(raster)
library(sp)
library(sf)
library(rgdal)
library(tidyverse)
library(rasterVis)
library(maptools)
library(mosaic)
library(parallel)
library(snow)

####Funciones
clasificar <- function(ras.ob, shp.ob){
  raster::beginCluster(n = 4)
  
  ras.ob <- raster::raster(file.choose())
  shp.ob <- readOGR(file.choose())
  
  f <- raster::extract(ras.ob, shp.ob)
  
  muni <- sapply(f, FUN = function(x) { prop.table(table(x)) })
  
  shtb <- as.tibble(shp.ob)
  
  geobase <- rbind_list(muni)
  
  raster::endCluster()
  
  mibase <- as.tibble(cbind(geobase, shtb))
  
} ### para analsis raster con valores discretos (Clasificacion)





stats <- function(ras.ob, shp.ob){
  raster::beginCluster(n = 4)
  
  ras.ob <- raster::raster(file.choose())
  shp.ob <- readOGR(file.choose())

  f <- raster::extract(ras.ob, shp.ob)
  
  shtb <- as.tibble(shp.ob)
  
  muni <- lapply(f, FUN = function(x) { fav.stats(x) })

  base <- rbind_list(muni)
  raster::endCluster()
  
  
  mibase <- as.tibble(cbind(base, shtb))
  
  } ### para analsis raster con valores continuos 

stats.table <- function(ras.ob, shp.ob){
  
  ras.ob <- raster::raster(file.choose())
  shp.ob <- readOGR(file.choose())
  
  f <- raster::extract(ras.ob, shp.ob)
}
