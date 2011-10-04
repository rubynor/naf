class Location
  include Mongoid::Document
  field :name, :type => String
  field :longitude, :type => Float
  field :latitude, :type => Float

  validates_presence_of :longitude, :latitude
end