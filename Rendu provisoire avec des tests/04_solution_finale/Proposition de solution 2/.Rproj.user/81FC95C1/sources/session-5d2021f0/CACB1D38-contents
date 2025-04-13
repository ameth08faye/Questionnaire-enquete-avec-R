# Module pour une question avec option "Autre"
# Ce module crée une question à choix multiples avec une option supplémentaire pour spécifier "Autre"

otherOptionQuestionUI <- function(id, label, mainChoices) {
  ns <- NS(id)
  
  div(
    checkboxGroupInput(ns("choices"), label, choices = mainChoices),
    checkboxInput(ns("has_other"), "Autre", width = "100%"),
    conditionalPanel(
      condition = paste0("input['", ns("has_other"), "']"),
      textInput(ns("other"), "Précisez", width = "100%")
    )
  )
}

otherOptionQuestionServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    return(
      reactive({
        list(
          choices = input$choices,
          has_other = input$has_other,
          other = if (isTRUE(input$has_other)) input$other else NULL
        )
      })
    )
  })
}