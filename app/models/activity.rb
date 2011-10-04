class Activity
  include Mongoid::Document

  field :name, :type => String

  field :location_id, :type => String
  field :category_id, :type => String

  embeds_one :location
  embeds_one :category

  before_validation :embedd_the_location, :embedd_the_category

  def embedd_the_location
    self.location = Location.find(self.location_id)
  end

  def embedd_the_category
    self.category = Category.find(self.category_id)
  end
end