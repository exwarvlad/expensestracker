$('.modal-backdrop').remove()
$("#myModal").html("<%= j render "form"%>")
$('#exampleModal').modal('show')