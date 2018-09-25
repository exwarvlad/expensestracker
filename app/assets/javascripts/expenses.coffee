## Default to JSON responses for remote calls
#$.ajaxSetup({
#  dataType: 'json'
#})
#
#$.fn.render_form_errors = (model_name, errors) ->
#  form = this
#  this.clear_form_errors()
#
#  $.each(errors, (field, messages) ->
#    input = form.find('input, select, textarea').filter(->
#      name = $(this).attr('name')
#      if name
#        name.match(new RegExp(model_name + '\\[' + field + '\\(?'))
#    )
#    input.closest('.form-group').addClass('has-error')
#    input.parent().append('<span class="help-block">' + $.map(messages, (m) -> m.charAt(0).toUpperCase() + m.slice(1)).join('<br />') + '</span>')
#  )
#
#$.fn.clear_form_errors = () ->
#  this.find('.form-group').removeClass('has-error')
#  this.find('span.help-block').remove()
#
#$.fn.clear_form_fields = () ->
#  this.find(':input','#myform')
#    .not(':button, :submit, :reset, :hidden')
#    .val('')
#    .removeAttr('checked')
#    .removeAttr('selected')