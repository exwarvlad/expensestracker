$('#exampleModal').modal('toggle')
$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")

$('<%=j "#col_#{@expense.id}" %>').html(
  '<td><%=j @expense.name %></td> ' +
  '<td><%=j @expense.current_currency %></td> ' +
  '<td><%=j @expense.expense_type %></td> ' +
  '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
  '<td><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
  '<td><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> '
)

<% currency_convert = CurrencyConvert.new(@expenses, current_user.filter.currency.name) %>
$('#total_sum').html('Total: ' + '<%= number_to_currency(currency_convert.transfer_transit, unit: currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')