$('#col_' + <%= params[:tr_id] %>).hide('slow', ->
 $(this).remove()
)

$('#total_sum').html('<%= t(:total) %>: ' + '<%= Expense.total_sum %>')
