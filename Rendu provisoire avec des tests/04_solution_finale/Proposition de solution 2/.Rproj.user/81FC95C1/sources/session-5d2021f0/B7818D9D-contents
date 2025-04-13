# global.R - variables et fonctions globales pour l'application

# Chargement des modules
source("modules/conditionalSelectModule.R")
source("modules/otherOptionModule.R")
source("modules/geoModule.R")

# Chargement des données géographiques
tryCatch({
  adm0_SN <- st_read("data/Shapefiles/sen_admbnda_adm0_anat_20240520.shp", quiet = TRUE)
  adm1_SN <- st_read("data/Shapefiles/sen_admbnda_adm1_anat_20240520.shp", quiet = TRUE)
  adm2_SN <- st_read("data/Shapefiles/sen_admbnda_adm2_anat_20240520.shp", quiet = TRUE)
  adm3_SN <- st_read("data/Shapefiles/sen_admbnda_adm3_anat_20240520.shp", quiet = TRUE)
  
  # Chargement des rasters
  population_raster <- tryCatch({
    terra::rast("data/raster/SEN_population_v1_0_gridded.tiff")
  }, error = function(e) {
    NULL
  })
}, error = function(e) {
  message("Erreur lors du chargement des données géographiques: ", e$message)
})

# Liste des régions, départements et communes du Sénégal (uniques)
regions_list <- unique(adm1_SN$ADM1_FR)
departements_list <- unique(adm2_SN$ADM2_FR)
communes_list <- unique(adm3_SN$ADM3_FR)

# Création des relations entre les entités administratives avec des valeurs uniques
region_dept_mapping <- lapply(split(adm2_SN$ADM2_FR, adm2_SN$ADM1_FR), unique)
dept_commune_mapping <- lapply(split(adm3_SN$ADM3_FR, adm3_SN$ADM2_FR), unique)

# Fonction pour collecter toutes les réponses
collectResponses <- function(input) {
  responses <- list(
    identification = list(
      coords = input$coords,
      zone = input$zone,
      pays = input$pays,                     # on récupère le pays via un input caché
      region = input$region_select,          # utiliser l'ID du menu déroulant pour la région
      departement = input$dept_select,         # ID pour le département
      commune = input$commune_select,          # ID pour la commune
      milieu = input$milieu,
      hhid = input$hhid,
      chef = input$chef,
      tel_principal = input$tel_principal
    ),
    
    # Page 1 - Information entretien
    entretien = list(
      num_compose = input$num_compose,
      participation = input$participation,
      raison_refus = input$participation_followup,
      nom_repondant = input$nom_repondant
    ),
    
    # Page 2 - Membres du ménage
    membres = list(
      nouveaux_membres = input$nouveaux_membres,
      membre_present = input$membre_present,
      raison_depart = input$raison_depart
    ),
    
    # Page 3 - Connaissances COVID-19
    covid_connaissances = list(
      entendu_corona = input$entendu_corona,
      mesures_adoptees = list(
        choices = input$mesures_adoptees,
        other = input$mesures_adoptees_other
      ),
      mesures_gouv = list(
        choices = input$mesures_gouv,
        other = input$mesures_gouv_other
      )
    ),
    
    # Page 4 - Comportements préventifs
    comportements = list(
      se_laver = input$se_laver,
      eviter_contact = input$eviter_contact,
      eviter_rassemblement = input$eviter_rassemblement,
      annuler_voyage = input$annuler_voyage,
      stock_nourriture = input$stock_nourriture
    ),
    
    # Page 5 - Situation professionnelle
    emploi = list(
      travail_semaine = input$travail_semaine,
      travailliez_avant = input$travailliez_avant,
      raison_arret = input$raison_arret,
      activite_principale = input$activite_principale,
      mode_travail = input$mode_travail
    )
  )
  
  return(responses)
}


# Fonction pour convertir les réponses en format plat pour l'export CSV
flattenResponses <- function(responses) {
  flat_data <- list()
  
  flatten_list <- function(lst, prefix = "") {
    for (name in names(lst)) {
      if (is.list(lst[[name]]) && !is.null(names(lst[[name]]))) {
        flatten_list(lst[[name]], paste0(prefix, name, "_"))
      } else {
        if (is.null(lst[[name]])) {
          flat_data[[paste0(prefix, name)]] <<- NA
        } else if (length(lst[[name]]) > 1) {
          flat_data[[paste0(prefix, name)]] <<- paste(lst[[name]], collapse = ";")
        } else {
          flat_data[[paste0(prefix, name)]] <<- lst[[name]]
        }
      }
    }
  }
  
  flatten_list(responses)
  return(as.data.frame(flat_data, stringsAsFactors = FALSE))
}

# Fonction pour valider les réponses
validateResponses <- function(responses) {
  errors <- c()
  
  if (is.null(responses$identification$coords) || responses$identification$coords == "") {
    errors <- c(errors, "Les coordonnées GPS sont requises")
  }
  
  if (is.null(responses$identification$region) || responses$identification$region == "") {
    errors <- c(errors, "La région est requise")
  }
  
  if (is.null(responses$identification$departement) || responses$identification$departement == "") {
    errors <- c(errors, "Le département est requis")
  }
  
  if (is.null(responses$identification$commune) || responses$identification$commune == "") {
    errors <- c(errors, "La commune est requise")
  }
  
  if (is.null(responses$entretien$participation) || responses$entretien$participation == "") {
    errors <- c(errors, "La participation est requise")
  }
  
  if (responses$entretien$participation == "Non" && 
      (is.null(responses$entretien$raison_refus) || responses$entretien$raison_refus == "")) {
    errors <- c(errors, "La raison du refus est requise")
  }
  
  if (responses$covid_connaissances$entendu_corona == "Oui" && 
      length(responses$covid_connaissances$mesures_adoptees$choices) == 0) {
    errors <- c(errors, "Les mesures adoptées sont requises")
  }
  
  return(errors)
}
