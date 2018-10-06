<% displacement_calcuator = ExpensesHelper::DisplacementCalculator.new(@expenses_before, @expenses) %>
<% displacement_calcuator.add_for_creates %>
<% displacement_calcuator.add_for_removes %>
<% result = displacement_calcuator.add_for_edit_per_page(@expense) %>

$('#exampleModal').modal('toggle')
<% displacement_calcuator.for_removes.each do |exp_id| %>
position = "col_" + parseInt('<%= exp_id %>')
$("#" + position).hide('slow', ->
  $(this).remove()
)
<% end %>

<% if result.present? %>
  <% if result[:remove_position] == false %>
$('#col_' + '<%= @expense.id %>').html(
    '<td><%=j @expense.name %></td> ' +
    '<td><%=j @expense.current_currency %></td> ' +
    '<td><%=j @expense.expense_type %></td> ' +
    '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> '
)
  <% else %>
<% result[:remove_position] += 1 if result[:remove_position] == 9 %>
$("#search_list tr:eq('<%= result[:remove_position] %>')").remove()
$("#search_list tr:eq('<%= result[:position] %>')").before(
  '<tr id=<%=j "col_#{@expense.id}" %>>' +
    '<td><%=j @expense.name %></td> ' +
    '<td><%=j @expense.current_currency %></td> ' +
    '<td><%=j @expense.expense_type %></td> ' +
    '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
    '</tr>\''
)
  <% end %>
<% end %>

<% displacement_calcuator.for_adds.each do |item| %>
<% exp = item[:exp] %>
position = parseInt('<%= item[:position] %>')

if position == 9
  return position += 1

$("#search_list tr:eq("+position+")").before(
  '<tr id=<%=j "col_#{exp.id}" %>>' +
    '<td><%=j exp.name %></td> ' +
    '<td><%=j exp.current_currency %></td> ' +
    '<td><%=j exp.expense_type %></td> ' +
    '<td><%=j exp.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(exp), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(exp), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
    '</tr>\''
)
<% end %>

$('#pagination').html("<%= j(paginate @expenses.page(params[:page]), theme: 'twitter-bootstrap-4', pagination_class: 'pagination-sm', params: {controller: 'expenses', action: 'index'}) %>")
$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")
$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.edit_amount_from_expense(@before_expense, @expense), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')