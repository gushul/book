$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link) # look bellow for implementations
  false # always stops the action since code runs asynchronously

$.rails.confirmed = (link) ->
  link.removeAttr('data-confirm')
  link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  str = link.attr 'data-header'
  $modalBody = $('.model.model-destroyPopUp .content')
  $modalHeading = $('.model-destroyPopUp .header .lbold');
  $modalHeading.html("#{str}")
  $modalBody.html("#{message}")
  openModel("destroyPopUp")
  # $(".model.model-destroyInventoryTG").css("display","block");
  # $(".model.model-destroyInventoryTG").css("opacity","1");
  $('.model.model-destroyPopUp .confirm').on 'click', -> $.rails.confirmed(link)
  # $('.model.model-viewInventoryTG .confirm').on 'click', -> $.rails.confirmed(link)
  # alert("1")


