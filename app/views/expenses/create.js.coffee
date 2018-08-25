$('#exampleModal').modal('toggle')

$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")

$('#search_list tr:first').before(
  '<tr id=<%=j "col_#{@expense.id}" %>>' +
    '<td><%=j @expense.name %></td> ' +
    '<td><%=j @expense.current_currency %></td> ' +
    '<td><%=j @expense.expense_type %></td> ' +
    '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
  '</tr>\''
)

<% currency_convert = CurrencyConvert.new(@expenses, current_user.filter.currency.name) %>
$('#total_sum').html('Total: ' + '<%= number_to_currency(currency_convert.transfer_transit, unit: currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')
# clearing a yellow background of the input for a chrome
# https://stackoverflow.com/questions/29120333/remove-the-yellow-background-on-input-on-autofill#answer-29120510
#$('.clear_after_create').css('-webkit-box-shadow', '0 0 0px 1000px white inset')