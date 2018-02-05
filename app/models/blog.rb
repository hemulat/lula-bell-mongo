class Blog
  include Mongoid::Document
  include Mongoid::Paperclip
  field :title, type: String
  field :content, type: String
  field :created_at, type: DateTime
  field :url, type: String
  has_mongoid_attached_file :image,
    styles: {thumb: {geometry: "150x150#", convert_options: "-auto-orient"},
             medium: {geometry: "480x360#",convert_options: "-auto-orient"}}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
