# Application pour l'enquête au Sénégal
# app.R - fichier principal de l'application

# Chargement des packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(leaflet)
library(sf)
library(terra)
library(DT)
library(shinyWidgets)
library(dplyr)
library(readr)


# Chargement des fichiers de l'application
source("global.R")
source("ui.R")
source("server.R")

# Lancement de l'application
shinyApp(ui = ui, server = server)