class ItemRequest
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :title, type: String
  field :description, type: String
  field :studentID, type: Integer

  validates_presence_of :studentID
  validates_presence_of :description
  validates_presence_of :title

  validates_length_of :description, minimum: 50
  validates_length_of :studentID, minimum:9, maximum:9, message: "must be exactly 9 digits"
end
