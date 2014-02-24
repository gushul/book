$(function() {
  for (var k = 0; k < 96; k+=4) {
    $(".itg_def_quantity\\["+k+"\\]").on("click", function(event){
      event.preventDefault();
      var id = parseInt($(this).attr('id'));
      for (var i = id; i < id+4; i++) {
        var qnt =  $("#default").val();
        $("#inventory_template_group_quantity_available\\["+i+"\\]").val(qnt)
      }
    })  
  }
});