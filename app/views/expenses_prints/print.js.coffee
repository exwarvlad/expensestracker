$('#print').html '<%= j(render partial: 'for_print', locals: {
  expenses: @expenses,
  total_amount: @total_amount ,
  convert_currency: @convert_currency
}) %>'

window.print()