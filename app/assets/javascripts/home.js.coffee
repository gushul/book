$ ->
  
  $("button#login").click ->
    $(".screenfade").show()
    $(".model-login").show()
    $(".screenfade").animate(
      opacity: 0.5
    , 1000).delay 1000
    $(".model-login").animate(
      opacity: 1.0
    , 1000).delay 1000

  $('#datepicker').datepicker()
  $('#datepicker2').datepicker()
  
  $('#timepicker').timepicker()
  $('#timepicker2').timepicker()


  flash_notice_Callback = ->
    $("#flash_notice").fadeOut()

  $("#flash_notice").bind 'click', (ev) =>
    $("#flash_notice").fadeOut()
  setTimeout flash_notice_Callback, 5000

  flash_error_Callback = ->
    $("#flash_error").fadeOut()

  $("#flash_error").bind 'click', (ev) =>
    $("#flash_error").fadeOut()
  setTimeout flash_error_Callback, 5000

  flash_alert_Callback = ->
    $("#flash_alert").fadeOut()

  $("#flash_alert").bind 'click', (ev) =>
    $("#flash_alert").fadeOut()
  setTimeout flash_alert_Callback, 5000