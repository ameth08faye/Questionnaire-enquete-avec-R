# Module pour une question conditionnelle
# Ce module crée une question principale et affiche une question de suivi si une certaine valeur est sélectionnée

conditionalSelectQuestionUI <- function(id, label, choices, triggerValue, followUpLabel) {
  ns <- NS(id)
  
  div(
    selectInput(ns("answer"), label, choices = choices),
    conditionalPanel(
      condition = paste0("input['", ns("answer"), "'] == '", triggerValue, "'"),
      textInput(ns("followup"), followUpLabel)
    )
  )
}

conditionalSelectQuestionServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    return(
      reactive({
        list(
          answer = input$answer,
          followup = if (!is.null(input$answer) && input$answer == "Non") input$followup else NULL
        )
      })
    )
  })
}