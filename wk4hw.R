##packages
library(countrycode)
library(here)
library(tidyverse)
library(sf)
library(tmap)
library(tmaptools)

##read data

gi_data <- read_csv(here('Data', 'GII.csv'))
countries <- st_read(here('Data','World_Countries_(Generalized)_9029012925078512962.geojson'))

##diff inequality 2010 to 2019

names(gi_data)
gi_data <- gi_data %>%
  mutate(gidiff = gii_2019 - gii_2010)
head(gi_data$gidiff)

##join data

countries$iso3 <- countrycode(countries$COUNTRY, 
                                      origin = "country.name", 
                                      destination = "iso3c")
head(gi_data$iso3)
head(countries$iso3)


##map

gimap <- countries %>%
  merge(.,
        gi_data,
        by.x="iso3",
        by.y="iso3",
        no.dups=TRUE) 

tmap_mode("plot")
tm_shape(gimap) +
  tm_polygons(
    col = "gidiff",           # Set the fill variable here
    palette = "RdBu",           # Apply the desired color palette
    title = "Change in GII"    # Legend title
  ) +
  tm_layout(
    main.title = "Global Inequality Index from 2010-2019",
    main.title.position = "center",
    main.title.size = 1.5,
    legend.position = c("left", "bottom"),
    legend.title.size = 0.9                
  )
