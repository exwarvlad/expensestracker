$('#exampleModal').modal('toggle')

$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")
<% if Filter.filterable?(@expense.id, current_user.id) %>
<% tr_position = @expenses.page.find_index { |time| time.created_at.to_date == @expense.created_at.to_date } %>
$('#search_list tr:eq(<% tr_position %>)').before(
  '<tr id=<%=j "col_#{@expense.id}" %>>' +
    '<td><%=j @expense.name %></td> ' +
    '<td><%=j @expense.current_currency %></td> ' +
    '<td><%=j @expense.expense_type %></td> ' +
    '<td><%=j @expense.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(@expense), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(@expense), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
  '</tr>\''
)

tr_size = $('#expenses tbody tr').length

if tr_size == parseInt('<%= Expense::PAGINATE_PAGES %>') + 1
  $('#expenses tr:last').hide('slow', ->
    $(this).remove()
  )
<% end %>

$('#pagination').html("<%= j(paginate @expenses.page(params[:page]), theme: 'twitter-bootstrap-4', pagination_class: 'pagination-sm') %>")
$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.new_amount_from_expense(@expense.amount, @expense.currency.name), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')