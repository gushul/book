/*$(document).ready(function() {
  jQuery(".best_in_place").best_in_place();
});*/

jQuery(function() {
  // $('#reservation_date').datepicker({
  //   dateFormat: 'yy-mm-dd'
  // });
  // $.datepicker.setDefaults({ dateFormat: 'dd M (D)' });
});

$('select').change(auto_set_end_time);

function auto_set_end_time(dur, isOwner){
  if (isOwner) {
    var h = parseInt($("#reservation_start_time_4i").val());
    var m = parseInt($("#reservation_start_time_5i").val());
    var hplus=0;

    if ( (dur + m) < 60 ) {
      $("#reservation_end_time_4i").val(h);
      $("#reservation_end_time_5i").val(dur + m); 
    } else if ( (dur + m) >= 60  &&  (dur + m) < 120 ) {
      hplus+=1;
      h = h+hplus;
      if (h>23) {
        h = 23 -h;
      }
      $("#reservation_end_time_4i").val(h);
      var mm = "00";
      if ((dur + m - 60) == 0) {
        $("#reservation_end_time_5i").val(mm); 
      } else {
        $("#reservation_end_time_5i").val(dur + m - 60); 
      }
    }

    if ( h!=  parseInt($("#reservation_end_time_4i").val()) ) {
      if (h == 0 && hplus==0) {
        h = "00";
      } else if ( (h+hplus) < 10 ) {
        h = "0" + (h+hplus);
      } else {
        h = h+hplus;
      }
      $("#reservation_end_time_4i").val(h);
    }
  }

}; 
