function toggle_menu(val){
  if (val){
    document.getElementsByClassName("sidenav")[0].style.display = "block";
    document.getElementById("side-bar-cover").style.display = "block";
  }
  else{
    document.getElementsByClassName("sidenav")[0].style.display = "none";
    document.getElementById("side-bar-cover").style.display = "none";
  }
}
