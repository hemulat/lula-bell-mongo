var sidebarLink= document.getElementById("testbutton");
var item_container=document.getElementById("category-content");


sidebarLink.addEventListener("click", function(){
  var ourRequest=new XMLHttpRequest();
  ourRequest.open("GET", gon.items,true );
  ourRequest.onload=function() {
    var ourData= gon.items;
    console.log(gon.items);
    renderHTML(ourData);
    };
  ourRequest.send();
 });


function renderHTML(data){
  var HTMLtag="testing this ajax";
  item_container.insertAdjacentHTML('beforeend', HTMLtag);
};
// console.log(gon.items);
