$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously

$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  $modalBody = $('.model.model-destroyInventoryTG .content')
  $modalBody.html("#{message}")
  openModel("destroyInventoryTG")
  $('.model.model-destroyInventoryTG .confirm').on 'click', -> $.rails.confirmed(link)


