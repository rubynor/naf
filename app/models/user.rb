#encoding: UTF-8

class User
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  field :super_admin, :type => Boolean, :default => false

  belongs_to :location
  belongs_to :region
  has_many :activities
  before_validation :validate_access

  def validate_access
    if location.nil? && region.nil? && !super_admin
      errors[:base] << "Rettighet må være satt i form av super admin, regions-tilhørighet eller lokasjons-tilhørighet"
    end
  end

  def is_super_admin?
    super_admin
  end

  #get a list of location ids a user can manage
  def editable_locations
    return Location.all if is_super_admin?
    if self.region
      res = []
      region.locations.each do |lok|
        res += [lok] + lok.locations
      end
      res
    elsif self.location
      location + self.location.locations
    else
      []
    end
  end
  #get a list of location ids a user can manage
  def editable_location_ids
    return Location.all if is_super_admin?
    if self.region
      res = []
      region.locations.each do |lok|
        res += [lok.id.to_s] + lok.locations.map{|l| l.id.to_s}
      end
      res
    elsif self.location
      [location.id.to_s] + self.location.locations.map{|l|l.id.to_s}
    else
      []
    end
  end

end
