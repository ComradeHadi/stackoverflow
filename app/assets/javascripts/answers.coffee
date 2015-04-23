window.App ?= {}

# show answer#edit form
App.answer_edit = (event) ->
  event.preventDefault()
  answer_id = $(@).data('answerId')
  $(@).hide()
  $("#answer_body_" + answer_id).hide()
  $("#form_edit_answer_" + answer_id).show()

$(document).on 'click', '.answers .link_edit_answer', App.answer_edit

