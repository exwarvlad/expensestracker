<% displacement_calcuator = ExpensesHelper::DisplacementCalculator.new(@expense, Filter.check_expenses(current_user.id)) %>
$('#exampleModal').modal('toggle')

<% exp = displacement_calcuator.expense %>
<% if exp.present? %>
position = parseInt('<%= displacement_calcuator.position %>')
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

if tr_size == parseInt('<%= Expense::PAGINATE_PREV %>') + 2 # new exp and tr calibration
  $("#expenses tr:eq("+(tr_size - 1)+")").hide('slow', ->
    $(this).remove()
  )

$('#pagination').html("<%= j(paginate @expenses.page(params[:page]), theme: 'twitter-bootstrap-4', pagination_class: 'pagination-sm') %>")
$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")
$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.new_amount_from_expense(@expense.amount, @expense.currency.name), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')