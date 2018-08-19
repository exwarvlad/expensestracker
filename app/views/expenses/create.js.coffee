$('#exampleModal').modal('toggle')

$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")

$('#search_list tr:first').before(
  '<tr id=<%=j "col_#{@expense.id}" %>>' +
    '<td><%=j @expense.name %></td> ' +
    '<td><%=j @expense.currency %></td> ' +
    '<td><%=j @expense.expense_type %></td> ' +
    '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
  '</tr>\''
)

$('#total_sum').html('<%= t(:total) %>: ' + '<%= Expense.total_sum(current_user.id) %>')
# clearing a yellow background of the input for a chrome
# https://stackoverflow.com/questions/29120333/remove-the-yellow-background-on-input-on-autofill#answer-29120510
#$('.clear_after_create').css('-webkit-box-shadow', '0 0 0px 1000px white inset')