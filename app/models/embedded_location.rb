# -*- encoding : utf-8 -*-
class EmbeddedLocation
  include Mongoid::Document
  field :name, :type => String
  field :longitude, :type => Float
  field :latitude, :type => Float
  belongs_to :region
  embedded_in :activity, :inverse_of => :location

end
