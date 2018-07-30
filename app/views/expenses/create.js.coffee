$('#exampleModal').modal('toggle')

$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")

$('#search_list tr:first').before(
  '<tr id=<%=j "col_#{Expense.count + 1}" %>>' +
    '<td><%=j @expense.name %></td> ' +
    '<td><%=j @expense.currency %></td> ' +
    '<td><%=j @expense.expense_type %></td> ' +
    '<td><%=j @expense.created_at.to_s %></td> ' +
    '<td><%=j link_to 'Edit', edit_expense_path(@expense), class: 'btn btn-warning' %></td> ' +
    '<td><%=j link_to 'Destroy', expense_path(@expense, tr_id: Expense.count + 1), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
  '</tr>\''
)

$('#total_sum').html('<%= t(:total) %>: ' + '<%= Expense.total_sum %>')
# clearing a yellow background of the input for a chrome
# https://stackoverflow.com/questions/29120333/remove-the-yellow-background-on-input-on-autofill#answer-29120510
#$('.clear_after_create').css('-webkit-box-shadow', '0 0 0px 1000px white inset')