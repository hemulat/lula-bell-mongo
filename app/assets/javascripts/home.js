$(window).resize(function() {
   if ($(this).width() > 1000) {
     $(window).scroll(function(){
       var st = $(this).scrollTop(),
         winH = $(this).height(),
         add=100,
         posCart= $('#cart-container').position().top;
         if(st + winH >= posCart + add){
           $('#cart-container').stop().animate({opacity:1, marginTop:10},3500);
           $( "#cart" ).animate({ left: 4000},{duration: 3000,
         step: function( now, fx ){
               $( "#cart" ).css( "left", now );
             }
           })
         }else{
             $('#cart-container').css({opacity:0, marginTop:0},'fast');
         }
     });
   }
});

$(document).ready(function() {
   $(window).resize();
});

// $(window).scroll(function(){
//   var start = $(this).scrollTop(),
//       winH = $(this).height(),
//       /* you can set this add,
//       depends on where you want the animation to start
//       for example if the section height is 100 and you set add of 50,
//       that means if 50% of the section is revealed
//       on the bottom of viewport animate text
//       */
//       add = 50;
//
//   $('div').each(function(){
//       var pos = $(this).position().top;
//       if(st + winH >= pos + add){
//           $(this).stop().animate({opacity:1, marginTop:10},'fast');
//       }else{
//           $(this).stop().animate({opacity:0, marginTop:0},'fast');
//       }
//   });
// });
