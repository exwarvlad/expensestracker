<% displacement_calcuator = ExpensesHelper::DisplacementCalculator.new(@expenses_before, @expenses) %>
<% displacement_calcuator.add_for_creates %>
<% displacement_calcuator.add_for_removes %>

$('#exampleModal').modal('toggle')
<% displacement_calcuator.for_removes.each do |exp_id| %>
position = "col_" + parseInt('<%= exp_id %>')
$("#" + position).hide('slow', ->
  $(this).remove()
)
<% end %>

<% displacement_calcuator.for_adds.each do |item| %>
<% exp = item[:exp] %>
position = parseInt('<%= item[:position] %>')
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

$('#pagination').html("<%= j(paginate @expenses.page(params[:page]), theme: 'twitter-bootstrap-4', pagination_class: 'pagination-sm') %>")
$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")

<% if Filter.filterable?({'user_id' => current_user.id, 'id' => @expense.id}) %>
$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.new_amount_from_expense(@expense.amount, @expense.currency.name), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')
<% end %>