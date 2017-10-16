# Dirk Eddelbutthead
#https://stackoverflow.com/questions/3053833/using-r-to-download-zipped-data-file-extract-and-import-data

# temp <- tempfile()
# download.file("https://firms.modaps.eosdis.nasa.gov/active_fire/viirs/shapes/zips/VNP14IMGTDL_NRT_Canada_24h.zip",temp)
# data <-unz(temp, "VNP14IMGTDL_NRT_Canada_24h.shp")
# unlink(temp)

library(sf)
library(leaflet)

## source : https://earthdata.nasa.gov/earth-observation-data/near-real-time/firms/active-fire-data

## https://earthdata.nasa.gov/earth-observation-data/near-real-time/firms/viirs-i-band-active-fire-data

## user guide : https://cdn.earthdata.nasa.gov/conduit/upload/3500/VIIRS_375m_Users_guide_Dec15_v2.pdf
download.file("https://firms.modaps.eosdis.nasa.gov/active_fire/viirs/shapes/zips/VNP14IMGTDL_NRT_Canada_24h.zip", destfile= "./data/test.zip")
utils::unzip("./data/test.zip", exdir="./data")

# importer et mapper le shapefile
sv_spdf <- st_read(
  "./data/VNP14IMGTDL_NRT_Canada_24h.shp", 
  stringsAsFactors = FALSE)

library(htmlwidgets)

mypal <- colorNumeric(palette = 'Oranges', 
                      domain = sv_spdf$BRIGHT_TI4)

m <- sv_spdf %>%  leaflet()%>%  
  addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
  addCircles(color = ~ mypal(BRIGHT_TI4), 
             fillColor = ~ mypal(BRIGHT_TI4),
             popup =  ~ BRIGHT_TI4) %>%
  addLegend("bottomleft", 
            pal = mypal, 
            values = ~ BRIGHT_TI4) 

saveWidget(m, file = "pouet.html")
