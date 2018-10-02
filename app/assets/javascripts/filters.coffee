# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.erb.erb.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$(window).on('load', ->
#  $('input[name=duration]').val(
#    $('#filter_date_duration').html()
#  )
#)
#return

$(document).ready ->
  $('.edit_user').submit ->
    $('#filter_data_duration').val(
      $('#filter_date_duration').html()
    )
  return
return
