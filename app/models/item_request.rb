class ItemRequest
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :studentID, type: Integer
end
