# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  $('#click_me').click ->
    $('#click_me').attr 'id', 'not_click_me'

  window.onbeforeprint = (event) ->
    $('#click_me').click()
    $('#click_me').attr 'id', 'not_click_me'
    return

  window.onafterprint = (event) ->
    $('#not_click_me').attr 'id', 'click_me'
    return

  return