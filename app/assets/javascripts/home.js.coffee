# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.bxslider').bxSlider({
    mode: 'fade',
    auto: true,
    # autoControls: true,
    pause: 4000
  });

  # $(".bxslider").mouseover ->
  #   $(".bx-wrapper .bx-controls-direction").css("display","inline");
  # $(".bxslider").mouseout ->
  #   $(".bx-wrapper .bx-controls-direction").css("display","none");
