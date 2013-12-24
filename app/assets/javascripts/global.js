function closeModel(name){
  $(".model-"+name).css("opacity","0");
  $(".model-"+name).hide();
  $(".screenfade").css("opacity","0");
  $(".screenfade").hide();
}
function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

$(document).ready(function(){
  var user,owner = "";
  user = $.cookie("user");
  owner = $.cookie("owner");
  if(user != "true"){
    if(getParameterByName('email') == "user" && getParameterByName('password') == "user"){
      $.cookie("user", "true");
      $.removeCookie("owner");
      user = "true";
      $("#login").hide();
      $("#signup").hide();
      $(".ownerUnlog").hide();
      $(".userLoged").show();
    }else{
      user = "false";
      $(".model-login .error").show();
      $("div #reservation").each(function(){
        $(this).attr("id","login");
      });
    }
  }else{
    $("#login").hide();
    $("#signup").hide();
    $(".ownerUnlog").hide();
    $(".userLoged").show();
  }

  if(owner != "true"){
    if(getParameterByName('owneremail') == "admin" && getParameterByName('ownerpassword') == "admin"){
      $.cookie("owner", "true");
      $.removeCookie("user");
      owner = "true";
      $("div #reservation").each(function(){
        $(this).removeClass("action");
      });
      $(".ownerLoged").show();
      $(".ownerUnlog").hide();
      $("#login").hide();
      $("#signup").hide();
    }else{
      owner = "false";
      $(".model-ownerlogin .error").show();
    }
  }else{
    $.removeCookie("user");
    $("div #reservation").each(function(){
        $(this).removeClass("action");
    });
    $(".ownerLoged").show();
    $(".ownerUnlog").hide();
    $("#login").hide();
    $("#signup").hide();
  }

  /* for search result page
  if(getParameterByName('check') == "false"){
    $(".model-check").show();
    $(".model-check .error").show();
    $(".model-check").animate({opacity: 1.0}, 1000).delay(1000);
    $(".screenfade").show();
    $(".screenfade").animate({opacity: 0.5}, 1000).delay(1000);
    $("div #reservation").each(function(){
      $(this).attr("id","check");
    });
  }else if(getParameterByName('check') == "true"){
    if(user == "true"){
      //$(".model-reservation").show();
      //$(".model-reservation").animate({opacity: 1}, 1000).delay(1000);
    }else if(user == "false"){
      $(".model-login").show();
      $(".model-login .error").show();
      $(".model-login").animate({opacity: 1}, 1000).delay(1000);
      $(".screenfade").show();
      $(".screenfade").animate({opacity: 0.5}, 1000).delay(1000); 
      $("div #reservation").each(function(){
        $(this).attr("id","login");
      });
    }else{
      $(".model-login .error").show();
      $(".model-login").animate({opacity: 1}, 1000).delay(1000);
      $(".screenfade").show();
      $(".screenfade").animate({opacity: 0.5}, 1000).delay(1000);
      $("div #reservation").each(function(){
        $(this).attr("id","login");
      });
    } 
  }else{
    $("div #reservation").each(function(){
      $(this).attr("id","check");
    });
    $(".model-check").show();
    $(".model-check").animate({opacity: 1.0}, 1000).delay(1000);
    $(".screenfade").show();
    $(".screenfade").animate({opacity: 0.5}, 1000).delay(1000);
  }
  //end search result
  */

  $( ".action" ).click(function(){
    $(".model").hide();
    $(".model").css("opacity","0");
    var actionName = $(this).attr("id");
    $(".model-"+actionName).show();
    $(".model-"+actionName).animate({opacity: 1.0}, 1000).delay(1000);
    $(".screenfade").show();
    $(".screenfade").animate({opacity: 0.5}, 1000).delay(1000);
  });
});