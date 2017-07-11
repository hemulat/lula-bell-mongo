def seed_counter(class_name=Item)
  Counter.create(name: class_name.name, seq: 1)
  s = class_name.subclasses
  s.each {|c| seed_counter(c)}
end

def reset_counter
  Counter.all.destroy
  seed_counter
end

def seed_super_admin(e="test@example.com", p = "password")
  Admin.create(email: e, superadmin: true, password: p)
end
