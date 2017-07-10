class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  field :student_id, type: Integer
  field :email, type: String
  field :item_id, type: BSON::ObjectId
  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :return_date, type: DateTime

  validates_presence_of :student_id
  validates_confirmation_of :student_id
  validates :email, :presence => true
end
