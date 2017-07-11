class Item
  include Mongoid::Document
  include Mongoid::Paperclip
  field :name, type: String
  field :rentable, type: Mongoid::Boolean
  field :reservable, type: Mongoid::Boolean
  field :description, type: String
  field :_sku, type: String
  field :_status, type: String, default: "Available"

  has_many :transactions
  
  scope :available, -> {where(_status: "Available")}

  validates_presence_of :name
  has_mongoid_attached_file :image,
    styles: { :thumb => "150x150#", :medium => "400>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/



  def options
    {_status: ["Checked Out", "In Laundray", "Available"]}
  end

  protected
    def self.required_fields
      validators.select do |v|
        v.is_a?(Mongoid::Validatable::PresenceValidator)
      end.map(&:attributes).flatten.map { |a_field| a_field.to_s }
    end

    def self.next_sku
      sku_str = ""
      cur_clas = self
      while cur_clas != Item do
        sku_str = cur_clas.name[0] + sku_str
        cur_clas = cur_clas.superclass
      end
      return "#{sku_str}#{Counter.next(self.name)}"
    end

end

class Kitchen < Item
end

class Clothing < Item
  field :type, type: String
  field :color, type: String
  field :fit, type: String
  field :size, type: String
  validates_presence_of :type, :fit

  def options
    {type: ['Winter', "Formal", "Professional", "Shoes","Other"],
     fit: %w"M W Jr Uni BT Plus"}
  end
end

class SchoolSupply < Item
end

class FreeStore < Item
end

class CookingEquipment < Kitchen
  field :type, type: String
  field :size, type: String
  validates_presence_of :type

  def options
    {type: ["Pot", "Pan", "Utensil", "Other"]}
  end

end

class Food < Kitchen
  field :type, type: String
  field :expiration, type: Time
  field :restriction, type: Array
  validates_presence_of :type

  def options
    {type: ["Fruit", "Vegetables", "Meat", "Dairy", "Other"],
     restriction: ['Vegan','Vegetarian','Gluten Free','Kosher']}
  end
end

class Hygiene < Item
end

class Cleaning < Item
end


class Book < SchoolSupply
  field :type, type: String
  field :author, type: String
  field :ISBN, type: String
  validates_presence_of :type, :author

  def options
    {type: ["Textbook", "General Reading", "Test Prep.", "Other"]}
  end
end


class Technology < SchoolSupply
end

class Furniture < FreeStore
end

class Appliance < FreeStore
end
