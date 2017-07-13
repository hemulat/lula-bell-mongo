class Reserve
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  field :item_id, type: BSON::ObjectId
  field :qty_id, type: Integer
  field :student_id, type: Integer
  field :email, type: String
  field :start_date, type: Date
  field :end_date, type: Date
  
end
