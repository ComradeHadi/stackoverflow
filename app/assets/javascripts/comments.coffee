window.App ?= {}

# show comments#new form
App.comments_new = (event) ->
  event.preventDefault()
  container = $(@).data('container')
  $(@).hide()
  $("#form_new_comment_for_" + container).show()

$(document).on 'click', '.link_new_comment', App.comments_new
