require 'nokogiri'
require 'restclient'

#
# gets location from NAF and store them as locations in the DB
#
desc "Get the location from NAF site"
task :scrape_locations => :environment do
  Location.destroy_all
  resource = RestClient.get 'beta.naf.no/Medlemskap/Kategorier/NAF-Lokalt/'
  doc = Nokogiri::HTML(resource)
  doc.css('script').each do |string|
   lat = ""
   lng = ""
   name = ""
   lat = string.content.match(/latitude:[-+]?[0-9]*\.?[0-9]*/)[0].split(":")[1] rescue nil
   lng = string.content.match(/longitude:[-+]?[0-9]*\.?[0-9]*/)[0].split(":")[1] rescue nil
   name = string.content.match(/toolTip:.*"/)[0].split(":")[1].gsub(/"/, '').gsub(/\\/, '').gsub(/\s\s/, " ") rescue nil
   if !lat.blank? && !lng.blank? && !name.blank?
     Location.create(:name => name, :longitude => lng, :latitude => lat)
   end
  end

end