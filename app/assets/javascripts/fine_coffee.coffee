$(document).ready ->
  $('#search').on 'keyup', ->
    value = $(this).val().toLowerCase()
    $('#search_list tr').filter ->
      $(this).toggle $(this).text().toLowerCase().indexOf(value) > -1
      return
    return
  return

add_value = () ->
  selected_option = 'select option:first'
  $(selected_option).attr('value', $(selected_option).text())

$(document).ready ->
  add_value()

console.log 42

$(document).ready ->
  $('input[name="dates"]').daterangepicker()

$(document).ready ->
  $('#myModal').on 'shown.bs.modal', ->
    add_value()
  return
