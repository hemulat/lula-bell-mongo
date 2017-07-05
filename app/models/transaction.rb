class Transaction
  include Mongoid::Document
  field :student_id, type: Integer
  field :start_date, type: Date
  field :end_date, type: Date
  field :status, type: String
end
