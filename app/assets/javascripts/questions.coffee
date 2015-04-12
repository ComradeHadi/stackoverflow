window.App ?= {}

# show question#edit form
App.question_edit = (event) ->
  event.preventDefault()
  question_id = $(@).data('questionId')
  $(@).hide()
  $("#question_item").hide()
  $("form#for_question_edit").show()

# show answer#edit form
App.answer_edit = (event) ->
  event.preventDefault()
  answer_id = $(@).data('answerId')
  $(@).hide()
  $("#answer_body_" + answer_id).hide()
  $("form#for_answer_edit_" + answer_id).show()

# update #answers after answer#create
App.answer_create = (e, date, status, xhr) ->
  answer = $.parseJSON(xhr.responseText)
  id = answer.id
  is_question_author = answer.is_question_author
  $('#alert').empty()
  $('#notice').html(App.messages['answer.created'])

  attachments = ''
  for file in answer.attachments
    attachments += "<div id='file_#{file.id}'><a href='#{file.url}'>#{file.name}</a><a id='delete_file_#{file.id}' href='/files/#{file.id}' data-method='delete' rel='nofollow' data-remote='true'>Delete file</a></div>"

  edit_answer = if answer.is_author then "<a href='' data-answer-id='#{ id }' class='edit_answer_link' id='edit_answer_#{ id }'>Edit answer</a>" else ""

  delete_answer = if answer.is_author then "<a href='/answers/#{ id }' data-method='delete' rel='nofollow' data-remote='true' id='delete_answer_#{ id }'>Delete answer</a>" else ""

  accept_as_best = if is_question_author then "<a href='/answers/#{ id }/accept_as_best' data-method='patch' rel='nofollow' data-remote='true' class='accept_as_best' id='best_answer_#{ id }'>Accept as best answer</a>" else ""

  $('#answers_list').append("<tr id='answer_#{ id }'><td class='body'><div id='answer_body_#{ id }'>#{ answer.body }</div></td><td class='attachments'>#{ attachments }</td><td class='edit'>#{ edit_answer }</td><td class='delete'>#{ delete_answer }</td><td id='is_best_#{ id }' class='is_best'>#{ accept_as_best }</td></tr>")

App.answer_create_error = (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $('#notice').empty()
  $('#alert').empty()
  $.each errors, (index, value) ->
    $('#alert').append(value)

$(document).on 'click', '#question_edit_link', App.question_edit
$(document).on 'click', '#answers .edit_answer_link', App.answer_edit
$(document).on 'ajax:success', 'form#new_answer', App.answer_create
$(document).on 'ajax:error', 'form#new_answer', App.answer_create_error