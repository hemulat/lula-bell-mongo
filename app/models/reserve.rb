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

  validates_presence_of :student_id
  validates_length_of :student_id, :minimum => 9
  validates_presence_of :email
  validates_presence_of :start_date
  validates_presence_of :end_date

end
