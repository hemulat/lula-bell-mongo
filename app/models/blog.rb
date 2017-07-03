class Blog
  include Mongoid::Document
  include Mongoid::Paperclip

  field :title, type: String
  field :content, type: String
  field :created_at, type: DateTime

  has_mongoid_attached_file :image
end
