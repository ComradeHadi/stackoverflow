window.App ?= {}

# show question#edit form
App.question_edit = (event) ->
  event.preventDefault()
  question_id = $(@).data('questionId')
  $(@).hide()
  $("#item_question_" + question_id).hide()
  $("#form_edit_question_" + question_id).show()

# show answer#edit form
App.answer_edit = (event) ->
  event.preventDefault()
  answer_id = $(@).data('answerId')
  $(@).hide()
  $("#answer_body_" + answer_id).hide()
  $("#form_edit_answer_" + answer_id).show()

$(document).on 'click', '.question .link_edit_question', App.question_edit
$(document).on 'click', '.answers .link_edit_answer', App.answer_edit
