class Photo
  include Mongoid::Document
  mount_uploader :photo, PhotoUploader
end