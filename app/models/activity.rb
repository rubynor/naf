# encoding: UTF-8

class Activity
  include Mongoid::Document
  include Sunspot::Mongoid

  #x-cal fields
  field :summary, :type => String #summary of the event
  field :description, :type => String #description of the event
  field :contact, :type => String #contact info
  field :attendee, :type => String #link to booking
  field :url, :type => String #link to website
  field :dtstart, :type => DateTime #start of event
  field :dtend, :type => DateTime #end of event

  #additional fields
  field :region, :type => String
  field :price, :type => Float
  field :video, :type => String #link to youtube
  field :responsibility, :type => String #what the attendee needs to be responsible for
  field :vehicle, :type => String #what kind of veichle is needed (predefined)
  field :own_vehicle, :type => Boolean, :default => false #the attendee needs veichle
  field :supervisor_included, :type => Boolean, :default => false
  field :location_id, :type => String #ref to #Location
  field :tags, :type => String, :default => ""
  field :target, :type => String #represents who this activity is for .i.e "Barn 0-14" or "Eldre 65+"

  field :active, :type => Boolean, :default => false

  embeds_one :location
  belongs_to :category

  before_validation :embedd_the_location

  searchable do
    text :summary, :description, :tags, :vehicle
    string :target
    string :region
    string :category_id
    boolean :active
    time :dtstart, :trie => true
    text :location_name do
      location.name
    end
  end

  def embedd_the_location
    self.location = Location.find(self.location_id)
  end

  #in search categories, summary, age, tag, location, dtstart, dtend, veichle,

  class << self
    def perform_search(params)
      search = Activity.search do
        keywords params[:text] do
          highlight :summary, :description, :tags, :vehicle
        end

        if params[:admin]
          with(:active).any_of [true, false]
        else
          with(:active, true)
        end

        with(:region).any_of params[:regions].to_a if params[:regions] && !params[:regions].empty?
        with(:category_id).any_of params[:category_ids].to_a if params[:category_ids] && !params[:category_ids].empty?
        with(:target).any_of params[:targets].to_a if params[:targets] && !params[:targets].empty?
        if params[:dtstart]
          start = DateTime.new(params[:dtstart].split(".")[2].to_i, params[:dtstart].split(".")[1].to_i, params[:dtstart].split(".")[0].to_i)
          with(:dtstart).greater_than(start)
        end
        order_by :dtstart, :asc
        paginate :page => params[:page], :per_page => params[:limit] if params[:page] && params[:limit] #pagination is optional
      end
      return search.results, search.total
    end

    def fields_schema
      [
        {:nb => "Navn", :en => "summary", :type => "text_field"},
        {:nb => "Sted", :en => "location_id", :type => "select_box"},
        {:nb => "Målgruppe", :en => "target", :type => "select_box", :values => targets},
        {:nb => "Kategori", :en => "category_id", :type => "select_box", :values => Category.all.map{|c|{:_id => c.id.to_s, :name => c.name}}},
        {:nb => "Beskrivelse", :en => "description", :type => "text_area"},
        {:nb => "Kontaktinformasjon", :en => "contact", :type => "text_area"},
        {:nb => "Link til registrering", :en => "attendee", :type => "text_field"},
        {:nb => "Link til nettside", :en => "url", :type => "text_field"},
        {:nb => "Starter", :en => "dtstart", :type => "datepicker"},
        {:nb => "Avslutter", :en => "dtend", :type => "datepicker"},
        {:nb => "Pris", :en => "price", :type => "text_field"},
        {:nb => "Link til video (Youtube)", :en => "video", :type => "text_field"},
        {:nb => "Deltakerene må huske", :en => "responsibility", :type => "text_area"},
        {:nb => "Kjøretøy", :en => "veichle", :type => "select_box", :values => veichles},
        {:nb => "Deltaker trenger eget kjøretøy", :en => "own_veichle", :type => "check_box"},
        {:nb => "Instruktør på stedet", :en => "supervisor_included", :type => "check_box"},
        {:nb => "Tags", :en => "tags", :type => "text_field"}]
    end

    #list of possible targets an activity can be for
    def targets
      ['Barn 0 - 14', 'Ung 15 - 24', 'Voksen 25 - 65', 'Eldre 65 +']
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