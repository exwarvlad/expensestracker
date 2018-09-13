$('#exampleModal').modal('toggle')

$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")
<% if Filter.filterable?(@expense.id, current_user.id) %>
<% expense_position_calculate = ExpensesHelper::ExpensePositionCalculator.new(@expense, @expenses, params[:page].to_i, Expense::PAGINATE_PREV - 1) %>
<% if expense_position_calculate.visible? %>
<% exp = expense_position_calculate.expense %>
position = parseInt('<%= expense_position_calculate.position %>')
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

tr_size = $('#expenses tbody tr').length

if tr_size == parseInt('<%= Expense::PAGINATE_PREV %>') + 1
  $('#expenses tr:last').hide('slow', ->
    $(this).remove()
  )
<% end %>

$('#pagination').html("<%= j(paginate @expenses.page(params[:page].to_i), theme: 'twitter-bootstrap-4', pagination_class: 'pagination-sm') %>")
$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.new_amount_from_expense(@expense.amount, @expense.currency.name), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')