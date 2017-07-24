$(function() {
  $(document).on("click",".pagination a", function(e){
    e.preventDefault();
    $.get(this.href, null, null, "script");
    return false;
  });
});
