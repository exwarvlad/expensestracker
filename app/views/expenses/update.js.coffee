<% displacement_calcuator = ExpensesHelper::DisplacementCalculator.new(@expense, Filter.check_expenses(current_user.id).page(params[:page])) %>
$('#exampleModal').modal('toggle')
<% if @before_position == displacement_calcuator.position %>
$('<%=j "#col_#{@expense.id}" %>').html(
  '<td><%=j @expense.name %></td> ' +
  '<td><%=j @expense.current_currency %></td> ' +
  '<td><%=j @expense.expense_type %></td> ' +
  '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
  '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
  '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> '
)
<% elsif displacement_calcuator.expense.present? %>
before_position = parseInt '<%= @before_position %>'
position = parseInt '<%= displacement_calcuator.position %>'
$("#search_list tr:eq("+before_position+")").remove()
$("#search_list tr:eq("+position+")").before(
  '<tr id=<%=j "col_#{@expense.id}" %>>' +
    '<td><%=j @expense.name %></td> ' +
    '<td><%=j @expense.current_currency %></td> ' +
    '<td><%=j @expense.expense_type %></td> ' +
    '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
    '</tr>\''
)
<% else %>
before_position = parseInt '<%= @before_position %>'
$("#search_list tr:eq("+before_position+")").remove()
position = parseInt '<%= displacement_calcuator.position %>'
$('#search_list tr:last').before(
  '<tr id=<%=j "col_#{displacement_calcuator.exp_of_prev_page.id}" %>>' +
    '<td><%=j displacement_calcuator.exp_of_prev_page.name %></td> ' +
    '<td><%=j displacement_calcuator.exp_of_prev_page.current_currency %></td> ' +
    '<td><%=j displacement_calcuator.exp_of_prev_page.expense_type %></td> ' +
    '<td><%=j displacement_calcuator.exp_of_prev_page.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(displacement_calcuator.exp_of_prev_page), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(displacement_calcuator.exp_of_prev_page), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
    '</tr>\''
)
<% end %>

$('#pagination').html("<%= j(paginate @expenses.page(params[:page]), theme: 'twitter-bootstrap-4', pagination_class: 'pagination-sm') %>")
$('.notice').html("<%=j render 'layouts/messages' %>")
$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.edit_amount_from_expense(@expense, @before_expense), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')