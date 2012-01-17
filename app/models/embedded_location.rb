# -*- encoding : utf-8 -*-
class EmbeddedLocation
  include Mongoid::Document
  field :name, :type => String
  field :longitude, :type => Float
  field :latitude, :type => Float
  belongs_to :region
  embedded_in :activity, :inverse_of => :location

  #validates_presence_of :name #:longitude, :latitude,

  before_save :nil_if_blank

  def nil_if_blank
    self.longitude = nil if self.longitude.blank?
    self.latitude = nil if self.latitude.blank?
  end
end
