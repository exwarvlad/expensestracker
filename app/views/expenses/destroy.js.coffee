$('#col_' + <%= params[:id] %>).hide('slow', ->
 $(this).remove()
)

$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.delete_amount_from_expense(@expense.amount, @expense.currency.name), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')
$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")
