$('#col_' + <%= params[:id] %>).hide('slow', ->
 $(this).remove()
)

<% if @exp %>
$("#search_list tr:last").after(
  '<tr id=<%=j "col_#{@exp.id}" %>>' +
    '<td><%=j @exp.name %></td> ' +
    '<td><%=j @exp.current_currency %></td> ' +
    '<td><%=j @exp.expense_type %></td> ' +
    '<td><%=j @exp.created_at.strftime('%d.%m.%Y') %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Edit', edit_expense_path(@exp), remote: true, class: 'btn btn-warning' %></td> ' +
    '<td class="not-for-print"><%=j link_to 'Destroy', expense_path(@exp), remote: true, method: :delete, class: 'btn btn-danger destroyer' %></td> ' +
    '</tr>\''
)
<% end %>

$('#pagination').html("<%= j(paginate @expenses.page(params[:page].to_i), theme: 'twitter-bootstrap-4', pagination_class: 'pagination-sm') %>")
$('#total_sum').html('Total: ' + '<%= number_to_currency(current_user.currency_convert.delete_amount_from_expense(@expense.amount, @expense.currency.name), unit: current_user.currency_convert.convert_currency, delimiter: ' ', format: '%n %u') %>')
$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")
