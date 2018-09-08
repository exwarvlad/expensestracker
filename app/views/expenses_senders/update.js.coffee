$('#senderModal').modal('toggle')
$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")