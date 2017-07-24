class Item
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Attributes::Dynamic

  field :name, type: String
  field :rentable, type: Mongoid::Boolean
  field :reservable, type: Mongoid::Boolean
  field :maximum_reservation_days, type: Integer,
                                  default: lambda {max_reservation}
  field :description, type: String
  field :_SKU, type: String
  field :_status, type: String, default: "Available"
  field :_quantity, type: Array, default: [1]
  field :quantity, type: Integer, default: 1


  has_many :transactions, dependent: :destroy
  has_many :reservations, class_name: "Reserve", inverse_of: :item,
                          dependent: :destroy

  scope :available, -> {where(:_quantity.ne =>[])}

  validates_presence_of :name
  has_mongoid_attached_file :image,
    styles: { :thumb => "150x150#", :medium => "400>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/



  def options
    {_status: ["Checked Out", "In Laundry", "Available"]}
  end

  def qty_ids()
    qty_ids = (self._quantity).clone
    self.transactions.each do |t|
      if t.return_date.nil? && !t.end_date.nil?
        qty_ids.push(t.qty_id.to_i)
      end
    end
    return qty_ids
  end

  def available_quantity_ids()
    current = self._quantity.clone
    reserved = []
    self.reservations.each do |r|
      reserved.push(r.qty_id.to_i)
    end
    current.select {|i| !reserved.include?(i.to_i)}
  end

  protected
    def max_reservation
      3
    end

    def self.shorthand
      self.name[0]
    end

    def self.required_fields
      validators.select do |v|
        v.is_a?(Mongoid::Validatable::PresenceValidator)
      end.map(&:attributes).flatten.map { |a_field| a_field.to_s }
    end

    def self.next_sku
      sku_str = ""
      cur_clas = self
      while cur_clas != Item do
        sku_str = cur_clas.shorthand + sku_str
        cur_clas = cur_clas.superclass
      end
      return "#{sku_str}#{Counter.next(self.name)}"
    end

end

class Kitchen < Item
  def max_reservation
    2
  end
end

class Hygiene < Item
end

class Cleaning < Item
  def self.shorthand
    "Cln"
  end
end


class Clothing < Item
  field :type, type: String
  field :color, type: String
  field :fit, type: String
  field :size, type: String
  validates_presence_of :type, :fit

  def options
    {type: ['Winter', "Formal", "Professional", "Shoes","Other"],
     fit: ["Men", "Women", "Junior", "UniSex", "Big and Tall", "Plus"]}
  end

  def self.shorthand
    "Clo"
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

  def self.shorthand
    return 'Co'
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
