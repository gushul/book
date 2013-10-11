$(function() {
  for (var k = 0; k < 96; k+=4) {
    $(".it_def_quantity\\["+k+"\\]").on("click", function(event){
      event.preventDefault();
      var id = parseInt($(this).attr('id'));
      for (var i = id; i < id+4; i++) {
        $("#inventory_template_quantity_available\\["+i+"\\]").val(10)
      }
    })  
  }
});