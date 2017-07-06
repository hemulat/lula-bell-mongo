
def flip_a_coin
  rand(2) == 0 ? false : true
end

def attach_images()
  file = File.open("app/assets/images/apple.jpg")
  @items = Item.all
  @items.each do |item|
    item.image = file
    item.save
  end
  file.close
end

def  g_items(n=5)
  (1..n).each do |i|
    na = "Item #{rand(3*n)}"
    rent = flip_a_coin
    reserve = rent ? flip_a_coin : false
    descr = "This is a general item with only bare minimum item requirement"
    Item.create({name: na, rentable: rent, reservable: reserve,
                description: descr})
  end
end

def g_kitchen_items(n=5)
  (1..n).each do |i|
    na = "Kitchen Item #{rand(3*n)}"
    rent = flip_a_coin
    reserve = rent ? flip_a_coin : false
    descr = "Not just any Item - This item belongs in the Kitchen section"
    Kitchen.create({name: na, rentable: rent, reservable: reserve,
                description: descr})
  end
end

def g_hygiene_items(n=5)
  (1..n).each do |i|
    na = "Hygiene Item #{rand(3*n)}"
    rent = flip_a_coin
    reserve = rent ? flip_a_coin : false
    descr = "A Hygine item - use it to keep yourself clean"
    Hygiene.create({name: na, rentable: rent, reservable: reserve,
                description: descr})
  end
end

def g_cleaning_items(n=5)
  (1..n).each do |i|
    na = "Cleaning Item #{rand(3*n)}"
    rent = flip_a_coin
    reserve = rent ? flip_a_coin : false
    descr = "A Cleaning item - use it to keep your stuff clean"
    Cleaning.create({name: na, rentable: rent, reservable: reserve,
                description: descr})
  end
end

def g_cooking_equipments(n=5)
  (1..n).each do |i|
    typ = ["Pot", "Pan", "Utensil", "Cooking Equipment"].sample
    na = "#{typ} #{rand(3*n)}"
    rent = flip_a_coin
    reserve = rent ? flip_a_coin : false
    descr = "A Kitchen item, specifically useful for cooking"
    CookingEquipment.create({name: na, rentable: rent, reservable: reserve,
                description: descr, type: typ})
  end
end

def g_food(n=5)
  (1..n).each do |i|
    restri = ['Vegan','Vegetarian','Gluten Free','Kosher'].shuffle[0..rand(5)]
    typ = ["Fruit", "Vegetables", "Meat", "Dairy", "Food"].sample
    na = "#{typ} #{rand(3*n)}"
    rent = false
    reserve = rent ? flip_a_coin : false
    exp = Time.now + rand(n).day
    descr = "#{typ} that is #{restri.join(",")}"
    Food.create({name: na, rentable: rent, reservable: reserve,
                description: descr, type: typ, expiration: exp,
                restriction:restri})
  end
end


def g_clothing(n=5)
  (1..n).each do |i|
    typ = ['Winter', "Formal", "Professional", "Shoes", ""].sample
    colo = ["Black", "White", "Red", "Blue", "Green", "Yellow"].sample
    na = "#{typ} #{rand(3*n)}"
    rent = flip_a_coin
    fit = "M/W/Jr/Uni/BT/Plus".split('/').sample
    reserve = rent ? flip_a_coin : false
    descr = "#{colo} #{typ} - put it on if it fits you"
    Clothing.create({name: na, rentable: rent, reservable: reserve,
                description: descr, color: colo, type:typ,
                fit: fit, size:rand(42)})
  end
end

def g_school_supplies(n=5)
  (1..n).each do |i|
    na = "School Supply #{rand(n)}"
    rent = flip_a_coin
    reserve = rent ? flip_a_coin : false
    descr = "This is a general school supply."
    SchoolSupply.create({name: na, rentable: rent, reservable: reserve,
                description: descr})
  end
end

def g_books(n=5)
  (1..n).each do |i|
    typ = "Text,General reading,Test prep,".split(',').sample
    na = "#{typ} Book #{rand(3*n)}"
    rent = flip_a_coin
    reserve = rent ? flip_a_coin : false
    auth = "Superman,Batman,Wonder woman,Ironman,Black Widow".split(',').sample
    descr = "A #{typ} Book - use it to improve yourself"
    isb = "123456789015973".split("").shuffle.join("")
    Book.create({name: na, rentable: rent, reservable: reserve,
                description: descr, type:typ,author:auth, ISBN:isb})
  end
end

def g_all(num = 5)
  g_items(num)
  g_kitchen_items(num)
  g_hygiene_items(num)
  g_cleaning_items(num)
  g_cooking_equipments(num)
  g_food(num)
  g_clothing(num)
  g_school_supplies(num)
  g_books(num)
end

def remove_all
  Item.destroy_all
end
