$('#col_' + <%= params[:id] %>).hide('slow', ->
 $(this).remove()
)

<% currency_convert = CurrencyConvert.new(@expenses, current_user.filter.currency.name) %>
$('#total_sum').html('Total: ' + '<%= number_to_currency(currency_convert.transfer_transit, unit: currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')
$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")
