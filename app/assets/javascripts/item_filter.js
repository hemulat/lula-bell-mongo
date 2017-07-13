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
  var htmlString="";

  for (i=0; i<data.length; i++){
    htmlString+=
      "<div class=\"row\">"
          +"<div class=\"col-sm-6 col-md-2\">" +
            "<div class=\"thumbnail\">"
              +"<a href=\"items\\" +data._id.$oid+ "\">Link"
                +"<div class=\"caption\">"
                  +data.name +"<br>"
                  + "</div>"
              +"</a>"
            +"</div>"
          +"</div>"
        +"</div>"
  }

  item_container.insertAdjacentHTML('beforeend', htmlString);
};
// console.log(gon.items);
