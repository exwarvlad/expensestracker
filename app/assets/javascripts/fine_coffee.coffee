$(document).ready ->
  $('#search').on 'keyup', ->
    value = $(this).val().toLowerCase()
    $('#search_list tr').filter ->
      $(this).toggle $(this).text().toLowerCase().indexOf(value) > -1
      return
    return
  return


console.log 42

$(document).ready ->
  $('input[name="dates"]').daterangepicker()
return
