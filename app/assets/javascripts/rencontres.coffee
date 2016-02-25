# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#rencontre_accomp_structure').autocomplete
  	source: $('#rencontre_accomp_structure').data('autocomplete-source')

jQuery ->
  $('#rencontre_sig_structure').autocomplete
  	source: $('#rencontre_sig_structure').data('autocomplete-source')