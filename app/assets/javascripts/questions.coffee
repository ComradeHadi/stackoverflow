window.App ?= {}

# show question#edit form
App.question_edit = (event) ->
  event.preventDefault()
  question_id = $(@).data('questionId')
  $(@).hide()
  $("#item_question_" + question_id).hide()
  $("#form_edit_question_" + question_id).show()

$(document).on 'click', '.question .link_edit_question', App.question_edit

