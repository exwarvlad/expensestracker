$('.modal-backdrop').remove()
$('body').removeAttr('style')
$("#myModal").html("<%= j render "form"%>")
$('#exampleModal').modal('show')