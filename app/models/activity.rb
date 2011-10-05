class Activity
  include Mongoid::Document
  include Sunspot::Mongoid

  searchable do
    text :summary
    text :description
  end

  #x-cal fields
  field :summary, :type => String #summary of the event
  field :description, :type => String #description of the event
  field :contact, :type => String #contact info
  field :attendee, :type => String #link to booking
  field :url, :type => String #link to website
  field :dtstart, :type => DateTime #start of event
  field :dtend, :type => DateTime #end of event

  #additional fields
  field :price, :type => Float
  field :video, :type => String #link to youtube
  field :responsibility, :type => String #what the attendee needs to be responsible for
  field :vehicle, :type => String #what kind of veichle is needed (predefined)
  field :own_vehicle, :type => Boolean, :default => false #the attendee needs veichle
  field :supervisor_included, :type => Boolean, :default => false
  field :location_id, :type => String #ref to #Location
  field :category_id, :type => String #ref to #Category
  field :tags, :type => String

  embeds_one :location
  embeds_many :categories

  before_validation :embedd_the_location, :embedd_the_category

  def embedd_the_location
    self.location = Location.find(self.location_id)
  end

  def embedd_the_category
    self.categories << Category.find(self.category_id) if self.categories.empty?
  end

  #in search categories, summary, age, tag, location, dtstart, dtend, veichle,

  class << self
    def perform_search(params)
      search = Activity.search { keywords params[:text] }
      return search.results
    end
  end
end