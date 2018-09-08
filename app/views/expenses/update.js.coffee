$('#exampleModal').modal('toggle')
$('.notice').html("<%=j render 'layouts/messages' %>")

$('<%=j "#col_#{@expense.id}" %>').html(
  '<td><%=j @expense.name %></td> ' +
  '<td><%=j @expense.current_currency %></td> ' +
  '<td><%=j @expense.expense_type %></td> ' +
  '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
  '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
  '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> '
)

$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.edit_amount_from_expense(@expense, @before_expense), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')