function toggle_element(class_name,cb_1,cb_2){
  if (cb_2 == undefined ){
    cb_2 = cb_1
  }
  var b1 = document.getElementById(cb_1);
  var b2 = document.getElementById(cb_2);
  var x = document.getElementsByClassName(class_name)[0];
  if (b1.checked && b2.checked) {
    x.style.display = 'block';
  }
  else {
    x.style.display = 'none';
  }
}

function toggle_rentable(){
  var rent_id = 'item_rentable';
  var reserv_id = 'item_reservable';

  toggle_element('item_reservable',rent_id);
  toggle_element('item_buffer_period',rent_id);
  toggle_element('item_maximum_reservation_days',rent_id,reserv_id);
}

function toggle_reservable(){
  var rent_id = 'item_rentable';
  var reserv_id = 'item_reservable';
  toggle_element('item_maximum_reservation_days',rent_id,reserv_id);
}

function initial_setup(){
  toggle_rentable();
}
