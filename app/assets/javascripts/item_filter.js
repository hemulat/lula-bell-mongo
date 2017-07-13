// var sidebarLink= document.getElementById("category");
// var item_container=document.getElementById("category-content");

var ourRequest=new XMLHttpRequest();
// console.log(gon.items);

ourRequest.open("GET", gon.items,true );

ourRequest.onload=function() {
  var ourData= gon.items;
  console.log(gon.items);
  // renderHTML(ourData);
  };
// var item_info= $('#item_display').data('item')

ourRequest.send();
console.log(gon.items);
// });

// sidebarLink.addEventListener("click", function(){


// function renderHTML(data){
//   item_container.insertAdjacentHTML('beforeend', 'testing123')
// }
