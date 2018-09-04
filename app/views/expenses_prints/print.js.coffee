$('#print').html '<%= j(render partial: 'expenses/for_print', locals: { expenses: @expenses }) %>'

window.print()