class Location
  include Mongoid::Document
  field :name, :type => String
  field :longitude, :type => Float
  field :latitude, :type => Float

  validates_presence_of :longitude, :latitude

  def to_marker
    {
      :name => name,
      :lat => latitude,
      :lng => longitude
    }
  end
end