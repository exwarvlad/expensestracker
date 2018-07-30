$('#exampleModal').modal('toggle')

console.log '<%=j params[:tr_id] %>'
$('#col_' + '<%=j params[:tr_id] %>').html(
  '<td>asd</td>'
)


$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")

$('#total_sum').html('<%= t(:total) %>: ' + '<%= Expense.total_sum %>')