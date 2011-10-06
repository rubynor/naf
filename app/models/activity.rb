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
  field :price, :type => Float
  field :video, :type => String #link to youtube
  field :responsibility, :type => String #what the attendee needs to be responsible for
  field :vehicle, :type => String #what kind of veichle is needed (predefined)
  field :own_vehicle, :type => Boolean, :default => false #the attendee needs veichle
  field :supervisor_included, :type => Boolean, :default => false
  field :location_id, :type => String #ref to #Location
  field :category_id, :type => String #ref to #Category
  field :tags, :type => String
  field :target, :type => String #represents who this activity is for .i.e "Barn 0-14" or "Eldre 65+"

  embeds_one :location
  embeds_many :categories

  before_validation :embedd_the_location, :embedd_the_category

  searchable do
    text :summary, :description
    string :target
    string :category_id
  end

  def embedd_the_location
    self.location = Location.find(self.location_id)
  end

  def embedd_the_category
    self.categories << Category.find(self.category_id) if self.categories.empty?
  end

  #in search categories, summary, age, tag, location, dtstart, dtend, veichle,

  class << self
    def perform_search(params)
      search = Activity.search do
        keywords params[:text] do
            highlight :summary, :description
        end
        with(:category_id).any_of params[:category_ids] if params[:category_ids] && !params[:category_ids].empty?
        with(:target).any_of params[:target] if params[:target]
      end
      return search.results
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
  end
end