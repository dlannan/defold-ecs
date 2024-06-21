$(document).ready(function() {

  $("#blur-effect").on("click", function(e) {
    $(this).val( 1 - $(this).val() );
    postData( "/world/camera/effect", { effect: "blur" }, function() {});
  });

  $("#grain-effect").on("click", function(e) {
    $(this).val( 1 - $(this).val() );
    postData( "/world/camera/effect", { effect: "grain" }, function() {});
  });

  $("#scanline-effect").on("click", function(e) {
    $(this).val( 1 - $(this).val() );
    postData( "/world/camera/effect", { effect: "scanlines" }, function() {});
  });

  $("#lcd-effect").on("click", function(e) {
    $(this).val( 1 - $(this).val() );
    postData( "/world/camera/effect", { effect: "lcd" }, function() {});
  });

});