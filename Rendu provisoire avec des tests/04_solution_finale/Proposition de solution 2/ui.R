# ui.R - Interface utilisateur

library(shiny)
library(shinyWidgets)  # pour actionBttn, radioGroupButtons, etc.

ui <- fluidPage(
  # On n'utilise plus useShinyjs(), on délègue l'affichage à du pur JS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css"),
    tags$script(src = "js/script.js")
  ),
  
  # Page d'accueil (affichée par défaut)
  div(
    id = "welcome-page",
    style = "display:block;",  # Visible au chargement
    div(class = "welcome-container",
        img(src = "images/worldbank-logo.png", class = "logo"),
        h1("Questionnaire Enquête Ménage - Sénégal"),
        p("Application pour la collecte de données sur les ménages au Sénégal"),
        div(class = "button-container",
            actionButton("start", "Commencer l'enquête", class = "start-btn"),
            # Bouton "Aide" -> côté JS on cible #help-btn
            actionButton("help-btn", "Aide", class = "help-btn"),
            # Bouton de téléchargement PDF (côté Shiny)
            downloadButton("download_guide", "Télécharger le guide d'utilisation", class = "guide-btn")
        )
    )
  ),
  
  # Contenu principal (masqué à l'initialisation, sera affiché via JS)
  div(
    id = "main-content",
    style = "display:none;",  # Caché par défaut, JS le rendra visible
    div(class = "header",
        div(class = "header-content",
            img(src = "images/worldbank-logo.png", class = "header-logo"),
            h2("Enquête Ménage - Sénégal")
        )
    ),
    
    # Menu de navigation
    div(class = "nav-container",
        tabsetPanel(
          id = "wizard", 
          type = "pills", 
          selected = "page0",
          tabPanel("Localisation", value = "page0"),
          tabPanel("Entretien",    value = "page1"),
          tabPanel("Membres",     value = "page2"),
          tabPanel("COVID-19",    value = "page3"),
          tabPanel("Comportements", value = "page4"),
          tabPanel("Emploi",      value = "page5"),
          tabPanel("Finalisation", value = "final")
        ),
        div(class = "nav-buttons",
            actionButton("prev", "Précédent"),
            actionButton("nextBtn", "Suivant")
        )
    ),
    
    # Contenu du questionnaire
    div(class = "content-container",
        uiOutput("pageContent")
    ),
    
    # Pied de page
    div(class = "footer",
        actionButton("back_to_home", "Retour à l'accueil"),
        downloadButton("download_data", "Télécharger les données"),
        actionButton("help", "Aide")
    ),
    
    # Modale d'aide (masquée de base)
    div(
      id = "help-modal",
      class = "modal",
      style = "display:none;",  # JS l'affichera
      div(class = "modal-content",
          span(id = "close-help", class = "close", "×"),
          h2("Aide"),
          tabsetPanel(
            tabPanel("Navigation",
                     p("Pour naviguer entre les sections du questionnaire..."),
                     p("Pour revenir à l'accueil...")
            ),
            tabPanel("Géolocalisation", 
                     p("Pour géolocaliser le ménage, sélectionnez une Région, un Département et une Commune ou utilisez la géolocalisation automatique.")
            ),
            tabPanel("Données", 
                     p("Toutes les données sont enregistrées localement...")
            ),
            tabPanel("Contact", 
                     p("Pour toute assistance technique...")
            )
          )
      )
    )
  )
)

