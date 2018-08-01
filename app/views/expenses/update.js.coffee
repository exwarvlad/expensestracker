$('#exampleModal').modal('toggle')

$('<%=j "#col_#{@expense.id}" %>').html(
  '<td><%=j @expense.name %></td> ' +
  '<td><%=j @expense.currency %></td> ' +
  '<td><%=j @expense.expense_type %></td> ' +
  '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
  '<td><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
  '<td><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> '
)


$('#total_sum').html('<%= t(:total) %>: ' + '<%= Expense.total_sum %>')