#console.log 123123
#alert 42
$('#exampleModal').modal('toggle')


$('#search_list tr:first').before(
  '<tr id=<%=j "col_#{Expense.count + 1}" %>>' +
    '<td><%=j @expense.name %></td> ' +
    '<td><%=j @expense.amount.to_s %></td> ' +
    '<td><%=j @expense.expense_type %></td> ' +
    '<td><%=j @expense.created_at.to_s %></td> ' +
    '<td><%=j link_to 'Edit', edit_expense_path(@expense), class: 'btn btn-warning' %></td> ' +
    '<td><%=j link_to 'Destroy', expense_path(@expense, tr_id: Expense.count + 1), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
  '</tr>\''
)