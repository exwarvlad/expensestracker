$('#col_' + <%= params[:tr_id] %>).hide('slow', ->
 $(this).remove()
)

$('#total_sum').html('<%= t(:total) %>: ' + '<%= @total_sum %>')
