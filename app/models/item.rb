class Item
  include Mongoid::Document
  field :name, type: String
  field :rentable, type: Mongoid::Boolean
  field :reservable, type: Mongoid::Boolean
  field :description, type: String
  validates_presence_of :name
end

class Kitchen < Item
end

class Clothing < Item
  field :type, type: String
  field :color, type: String
  field :fit, type: String
  field :size, type: String
  validates_presence_of :type, :fit
end

class School_Supply < Item
end

class Free_Store < Item
end

class Cooking_Equipment < Kitchen
  field :type, type: String
  field :size, type: String
  validates_presence_of :type
end

class Food < Kitchen
  field :type, type: String
  field :expiration, type: Time
  field :restriction, type: String
  validates_presence_of :type
end

class Hygiene < Kitchen
end

class Cleaning < Kitchen
end


class Book < School_Supply
  field :type, type: String
  field :author, type: String
  field :ISBN, type: String
  validates_presence_of :type, :author
end


class Technology < School_Supply
end

class Furniture < Free_Store
end

class Appliance < Free_Store
end
