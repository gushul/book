function closeModel(name){
  $(".model-"+name).css("opacity","0");
  $(".model-"+name).hide();
  $(".screenfade").css("opacity","0");
  $(".screenfade").hide();
}

$(document).on('click', ".action", function(){
  $(".model").hide();
  $(".model").css("opacity","0");
  var actionName = $(this).attr("id");
  $(".model-"+actionName).show();
  $(".model-"+actionName).animate({opacity: 1.0}, 1000).delay(1000);
  $(".screenfade").show();
  $(".screenfade").animate({opacity: 0.5}, 1000).delay(1000);
});