# -*- encoding : utf-8 -*-

class Activity
  include Mongoid::Document
  include Sunspot::Mongoid

  field :summary, :type => String #summary of the event
  field :description, :type => String #description of the event
  field :address, :type => String
  field :contact_name, :type => String
  field :contact_email, :type => String
  field :contact_phone, :type => String
  field :contact, :type => String #contact info
  field :photo_id, :type => String
  field :attendee, :type => String #link to booking
  field :url, :type => String #link to website
  field :dtstart, :type => DateTime, :default => Time.zone.now #start of event
  field :dtend, :type => DateTime, :default => Time.zone.now #end of event
  field :price, :type => Float
  field :member_price, :type => Float
  field :free, :type => Boolean, :default => false
  field :mva, :type => Boolean, :default => true
  field :video, :type => String #link to youtube
  field :responsibility, :type => String #what the attendee needs to be responsible for
  field :vehicle, :type => String #what kind of veichle is needed (predefined)
  field :own_vehicle, :type => Boolean, :default => false #the attendee needs veichle
  field :supervisor_included, :type => Boolean, :default => false
  field :traffic_safety, :type => Boolean, :default => false
  field :location_id, :type => String #ref to #Location
  field :organizer_id, :type => String #ref to #Location
  field :tags, :type => String, :default => ""

  field :age_from, :type => Integer, :default => 0
  field :age_to, :type => Integer, :default => 100
  field :active, :type => Boolean, :default => false


  field :score, :type => Integer, :default => 0

  field :photo_thumb_url, :type => String, :default => ""
  field :photo_medium_url, :type => String, :default => ""
  field :photo_large_url, :type => String, :default => ""

  embeds_one :location, :class_name => "EmbeddedLocation", :cascade_callbacks => true
  embeds_one :organizer, :class_name => "EmbeddedOrganizer", :cascade_callbacks => true

  embeds_one :internal_information, cascade_callbacks: true
  embeds_one :political_activity, cascade_callbacks: true
  accepts_nested_attributes_for :internal_information
  accepts_nested_attributes_for :political_activity
  #mount_uploader :photo, PhotoUploader

  belongs_to :category
  belongs_to :user

  before_save :embedd_objects, :set_photo_urls

  validates_presence_of :summary, :organizer_id, :location_id, :dtstart, :dtend, :category_id

  scope :by_start_date, all(sort: [[ :dtstart, :asc ]])
  scope :active, where(:active => true)


  searchable do
    text :summary, :description, :vehicle, :tags

    integer :age_from
    integer :age_to

    string :category_id

    boolean :active
    time :dtstart, :trie => true

    text :location_name do
      location.name if location
    end

    string :region_id do
      self.location.region_id.to_s if location
    end
  end

  def embedd_objects
    loc = Location.find(self.location_id)
    new_loc = EmbeddedLocation.new(:name => loc.name, :latitude => loc.latitude, :longitude => loc.longitude, :region_id => loc.region_id)
    self.location = new_loc

    org = Location.find(self.organizer_id)
    new_org = EmbeddedOrganizer.new(:name => org.name, :latitude => org.latitude, :longitude => org.longitude, :region_id => org.region_id)
    self.organizer = new_org
  end

  #OMA Code smell. Why isn't this associated or better, embedded? the storage of photo url also statically stores the bucket name and storage url now.
  def set_photo_urls
    unless self.photo_id.blank?
      photo = Photo.find(self.photo_id)
      self.photo_thumb_url = photo.photo.thumb
      self.photo_medium_url = photo.photo.medium
      self.photo_large_url = photo.photo.large
    end
  end
#  def photo_thumb_url
#    self.photo.thumb
#  end
#  def photo_medium_url
#    self.photo.medium
#  end
#  def photo_large_url
#    self.photo.large
#  end
  #in search categories, summary, age, tag, location, dtstart, dtend, veichle,

  class << self
    def perform_search(params)
      begin
      search = Activity.solr_search do

        keywords params[:text] do
          fields :summary, :description, :vehicle, :tags, :location_name
        end

        if params[:admin] && params[:admin].to_s == "true"
          with(:active).any_of [true, false]
        else
          with(:active, true)
        end

        if params[:region_id] && !params[:region_id].blank?
          with(:region_id, params[:region_id])
        end

        if params[:category_ids] && !params[:category_ids].to_a.empty?
           with(:category_id).any_of params[:category_ids].to_a
        end

        if params[:targets] && !params[:targets].empty?
          range = Activity.total_range_for_targets(params[:targets])
          min_age = range[0]
          max_age = range[1]
          with(:age_from).greater_than min_age
          with(:age_from).less_than max_age
          with(:age_to).greater_than min_age
        end

        if params[:dtstart]
          start = DateTime.new(params[:dtstart].split(".")[2].to_i, params[:dtstart].split(".")[1].to_i, params[:dtstart].split(".")[0].to_i)
          with(:dtstart).greater_than(start)
        end

        if params[:dtend]
          start = DateTime.new(params[:dtend].split(".")[2].to_i, params[:dtend].split(".")[1].to_i, params[:dtend].split(".")[0].to_i)
          with(:dtstart).less_than(start)
        end

        order_by :dtstart, :asc
        paginate :page => params[:page], :per_page => params[:limit] if params[:page] && params[:limit] #pagination is optional
      end

      return search.results, search.total
      rescue => e
        logger.error "something went wrong with search #{e}"
        if params[:admin] && params[:admin].to_s == "true"
          return Activity.all, Activity.all.size
        else
          return Activity.active, Activity.active.size
        end
      end
    end

    #list of possible targets an activity can be for
    def targets
      ['Barn 0 - 14', 'Ung 15 - 24', 'Voksen 25 - 65', 'Eldre 65 +']
    end

    def total_range_for_targets(targets)
      min = 100
      max = 0
      targets.to_a.each do |target|
        range = Activity.range_from_target(target)
        floor = range[0]
        ceil = range[1]
        min = floor if floor < min
        max = ceil if ceil > max
      end
      return [min, max]
    end

    def range_from_target(target)
      res = [0, 100]
      if target == 'Barn 0 - 14'
        res = [0, 14]
      elsif target == 'Ung 15 - 24'
        res = [15, 24]
      elsif target == 'Voksen 25 - 65'
        res = [25, 65]
      elsif target == 'Eldre 65 +'
        res = [65, 100]
      end
      return res
    end

    #list of possible veichles to choose from
    def veichles
      ['Bil', 'Moped', 'Motorsykkel', 'Tungt kjøretøy', 'ATV', 'Buss', 'Sykkel']
    end

    def regions
      ["Nord", "Sør", "Øst", "Vest", "Oslofjord"]
    end
  end
end
