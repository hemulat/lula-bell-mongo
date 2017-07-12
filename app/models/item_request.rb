class ItemRequest
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :title, type: String
  field :description, type: String
  field :studentID, type: Integer


end
