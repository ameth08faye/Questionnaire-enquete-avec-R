// script.js - JavaScript pour l'application d'enquête

$(document).ready(function() {

  // Bouton "Commencer l'enquête" : cache la page d'accueil, affiche le contenu principal et lance le timer
  $("#start").on("click", function() {
    $("#welcome-page").hide();
    $("#main-content").show();
    // Envoyer le timestamp (en millisecondes) au serveur pour démarrer le timer
    Shiny.setInputValue("start_clicked", Date.now(), {priority: "event"});
    Shiny.setInputValue("wizard", "page0");
  });

  // Bouton "Retour à l'accueil"
  $("#back_to_home").on("click", function() {
    $("#main-content").hide();
    $("#welcome-page").show();
  });

  // Boutons "Aide"
  $("#help-btn").on("click", function() {
    $("#help-modal").show();
  });
  $("#help").on("click", function() {
    $("#help-modal").show();
  });
  $("#close-help").on("click", function() {
    $("#help-modal").hide();
  });
  $(window).on("click", function(e) {
    if ($(e.target).hasClass("modal")) {
      $(".modal").hide();
    }
  });

  // Boutons "Suivant" / "Précédent"
  $("#nextBtn").on("click", function() {
    Shiny.setInputValue("nextBtn", "click", {priority: "event"});
  });
  $("#prev").on("click", function() {
    Shiny.setInputValue("prev", "click", {priority: "event"});
  });
});

  