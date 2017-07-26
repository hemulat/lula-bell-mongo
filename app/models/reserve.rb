class Reserve
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :qty_id, type: Integer
  field :student_id, type: Integer
  field :email, type: String
  field :start_date, type: Date
  field :end_date, type: Date

  belongs_to :item

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

  validates_presence_of :student_id
  validates_length_of :student_id, minimum: 9, maximum: 9
  validates_presence_of :email
  validates_format_of :email, with: EMAIL_REGEX
  validates_presence_of :start_date
  validates_presence_of :end_date
  validate :check_end_date

  def check_end_date
    max_r = self.item.maximum_reservation_days
    if self.end_date > self.start_date + max_r.days
      errors.add(:end_date,
                  "can't be more than #{max_r} days from the given Start Date")
      return false
    elsif self.end_date < self.start_date
      errors.add(:end_date,
                  "can't be before the given start date")
      return false
    else
      return true
    end
  end

end
