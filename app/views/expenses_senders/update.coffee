$('.notice').html("<%= escape_javascript(render 'layouts/messages') %>")
$('#senderModal').modal('toggle')