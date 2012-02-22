# -*- encoding : utf-8 -*-
module NafLocations

  def self.included(base)
      base.extend(ClassMethods)
  end

  module ClassMethods
    def scrape
      puts "antall lokasjoner #{Location.count}"
      resource = RestClient.get 'beta.naf.no/Medlemskap/Kategorier/NAF-Lokalt/'
      doc = Nokogiri::HTML(resource)
      locations = scrape_doc(doc)
      locs = locations.keys
      not_matched Location.not_in(name: locs).order_by([:name, :asc])
      new_locations locations, locs - Location.any_in(name: locs).map(&:name).to_a
    end

  private
    def scrape_doc(doc)
      locations = {}
      doc.css('script').each do |string|
       lat = ""
       lng = ""
       name = ""
       lat = string.content.match(/latitude:[-+]?[0-9]*\.?[0-9]*/)[0].split(":")[1] rescue nil
       lng = string.content.match(/longitude:[-+]?[0-9]*\.?[0-9]*/)[0].split(":")[1] rescue nil
       name = string.content.match(/toolTip:.*"/)[0].split(":")[1].gsub(/"/, '').gsub(/\\/, '').gsub(/\s\s/, " ") rescue nil
       unless name.blank?
         if lat.blank? || lng.blank?
           puts "missing lat=#{lat} or lng=#{lng} for #{name}"
         else
           #hacks
           #1
           name = "NAF Senter Harstad" if name == "NAF Senter Harstadt"
           #2
           name.gsub!("avd.", "Lokalavdeling")
           unless name == "Navn lokalavdeling"
             # OK - getting real. add location names to list and prepend NAF if missing.
             key = (name.starts_with?("NAF") ? name : "NAF " + name)
             locations[key]=[lat, lng]
           end
         end
       end

      end
      locations
    end
    def not_matched(locations)
      puts "existing locations not matched in new update to naf: #{locations.count}", locations.map(&:name)
      if locations.count > 0
        puts "  should they still be there? If not, remove in admin console"
      else
        puts "  none missing. excellent!"
      end

      locations.each do |l|
        if r = Location.where(name: l.name.gsub("NAF ", "")).first
          puts "typo? Should #{l.name} = #{r.first.name} ?"
        end
      end
    end
    def new_locations(locations, names)
      puts "new locations: #{names.size}", names.sort.reverse
      names.each.inject([]) do |newlocs, name|
        lat, lng = locations[name]
        newlocs << Location.new(name: name, latitude: lat, longitude: lng)
      end

    end

  end
end