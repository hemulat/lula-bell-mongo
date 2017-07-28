$(window).scroll(function(){
  var st = $(this).scrollTop(),
    winH = $(this).height(),
    add=100,
    posCart= $('#cart-container').position().top;
    if(st + winH >= posCart + add){
      $('#cart-container').stop().animate({opacity:1, marginTop:10},1000);
      $( "#cart" ).animate({ left: 4000},{duration: 3000,
        step: function( now, fx ){
                $( "#cart" ).css( "left", now );
              }
      })
    }
    else{
        $('#cart-container').css({opacity:0, marginTop:0},'slow');
    }
});
