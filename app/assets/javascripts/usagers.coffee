# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#usager_groupe_nom').autocomplete
  	source: $('#usager_groupe_nom').data('autocomplete-source')