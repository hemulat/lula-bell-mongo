class PsaPost
  include Mongoid::Document
  field :title, type: String
  field :text, type: String
  field :created_at, type: DateTime
end
