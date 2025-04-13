# Module pour la géolocalisation et l'affichage de la carte
# Ce module gère la géolocalisation et l'interaction avec la carte Leaflet

geoModuleUI <- function(id) {
  ns <- NS(id)
  
  div(
    actionBttn(ns("geoBtn"), "Géolocalisation automatique", 
               icon = icon("location-crosshairs"), 
               style = "material-flat", color = "primary"),
    textInput(ns("coords"), "Coordonnées GPS"),
    leafletOutput(ns("map"), height = "250px")
  )
}

geoModuleServer <- function(id, adm0_data, adm1_data, adm2_data, adm3_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Création de la carte de base
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        addPolygons(data = adm0_data, fillColor = "transparent", weight = 2, color = "black") %>%
        setView(lng = -14.4529, lat = 14.4974, zoom = 7)
    })
    
    # Réaction à la géolocalisation
    observeEvent(input$geoBtn, {
      session$sendCustomMessage(type = "getLocation", message = list())
    })
    
    # Observer pour mettre à jour la carte lorsque les coordonnées changent
    observe({
      req(input$coords)
      coords_text <- input$coords
      
      if (coords_text != "") {
        coords_parts <- strsplit(coords_text, ",")[[1]]
        if (length(coords_parts) == 2) {
          lat <- as.numeric(trimws(coords_parts[1]))
          lng <- as.numeric(trimws(coords_parts[2]))
          
          if (!is.na(lat) && !is.na(lng)) {
            leafletProxy("map") %>%
              clearMarkers() %>%
              addMarkers(lng = lng, lat = lat, popup = "Position du ménage")
          }
        }
      }
    })
    
    # Fonction pour mettre à jour la carte avec une région
    updateMapWithRegion <- function(region_name) {
      region_data <- adm1_data[adm1_data$ADM1_FR == region_name, ]
      
      leafletProxy("map") %>%
        clearShapes() %>%
        addPolygons(data = adm0_data, fillColor = "transparent", weight = 2, color = "black") %>%
        addPolygons(data = region_data, fillColor = "blue", weight = 1, color = "white", 
                    fillOpacity = 0.5)
      
      # Zoom sur la région
      if (nrow(region_data) > 0) {
        bbox <- st_bbox(region_data)
        leafletProxy("map") %>%
          fitBounds(bbox[["xmin"]], bbox[["ymin"]], bbox[["xmax"]], bbox[["ymax"]])
      }
    }
    
    # Fonction pour mettre à jour la carte avec un département
    updateMapWithDept <- function(dept_name) {
      dept_data <- adm2_data[adm2_data$ADM2_FR == dept_name, ]
      
      leafletProxy("map") %>%
        clearShapes() %>%
        addPolygons(data = adm0_data, fillColor = "transparent", weight = 2, color = "black") %>%
        addPolygons(data = dept_data, fillColor = "green", weight = 1, color = "white", 
                    fillOpacity = 0.5)
      
      # Zoom sur le département
      if (nrow(dept_data) > 0) {
        bbox <- st_bbox(dept_data)
        leafletProxy("map") %>%
          fitBounds(bbox[["xmin"]], bbox[["ymin"]], bbox[["xmax"]], bbox[["ymax"]])
      }
    }
    
    # Fonction pour mettre à jour la carte avec une commune
    updateMapWithCommune <- function(commune_name) {
      commune_data <- adm3_data[adm3_data$ADM3_FR == commune_name, ]
      
      leafletProxy("map") %>%
        clearShapes() %>%
        addPolygons(data = adm0_data, fillColor = "transparent", weight = 2, color = "black") %>%
        addPolygons(data = commune_data, fillColor = "red", weight = 1, color = "white", 
                    fillOpacity = 0.5)
      
      # Zoom sur la commune
      if (nrow(commune_data) > 0) {
        bbox <- st_bbox(commune_data)
        leafletProxy("map") %>%
          fitBounds(bbox[["xmin"]], bbox[["ymin"]], bbox[["xmax"]], bbox[["ymax"]])
      }
    }
    
    # Retourner les fonctions et les valeurs nécessaires
    return(list(
      coords = reactive(input$coords),
      updateWithRegion = updateMapWithRegion,
      updateWithDept = updateMapWithDept,
      updateWithCommune = updateMapWithCommune
    ))
  })
}