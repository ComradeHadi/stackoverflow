window.App ?= {}

# show answer#edit form
App.edit_answer = (event) ->
  answer_id = $(@).data('answerId')
  event.preventDefault()
  $(@).hide()
  $("#answer_body_" + answer_id).hide()
  $("form#for_answer_edit_" + answer_id).show()

# live binding
# still works after answer#update and reloading answers list
$(document).on 'click', '#answers .edit_answer_link', App.edit_answer

