class Photo
  include Mongoid::Document
  field :name, :type => String, :default => ""
  mount_uploader :photo, PhotoUploader

end