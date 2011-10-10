class Location
  include Mongoid::Document
  include Mongoid::Spacial::Document

  field :name, :type => String
  field :longitude, :type => Float
  field :latitude, :type => Float
  field :location, :type => Array, :spacial => true

  validates_presence_of :longitude, :latitude

  before_create :set_location

  spacial_index :location

  def set_location
    self.location = {:lat => self.latitude, :lng => self.longitude}
  end

  def to_marker
    {
      :name => name,
      :lat => latitude,
      :lng => longitude
    }
  end
end