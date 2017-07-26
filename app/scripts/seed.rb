def seed_counter(class_name=Item)
  Counter.create(name: class_name.name, seq: 1)
  s = class_name.subclasses
  s.each {|c| seed_counter(c)}
end

def re_seed(class_name=Item)
  if Counter.where(name: class_name.name).count == 0
    Counter.create(name: class_name.name, seq: 1)
  end
  s = class_name.subclasses
  s.each {|c| re_seed(c)}
end

def reset_counter
  Counter.all.destroy
  seed_counter
end

def seed_super_admin(e="test@example.com", p = "password")
  Admin.create(email: e, superadmin: true, password: p)
end
