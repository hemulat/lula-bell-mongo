class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  field :student_id, type: Integer
  field :email, type: String
  field :start_date, type: DateTime, default: proc {DateTime.now}
  field :end_date, type: DateTime
  field :return_date, type: DateTime

  belongs_to :item

  validates_presence_of :student_id
  validates_confirmation_of :student_id
  validates_presence_of :start_date

end
