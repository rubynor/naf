#
# put each location into the right region
#

task :populate_locations => :environment do
  file = File.open("#{Rails.root}/lib/tasks/locations.json")

  locations = JSON.parse(file.read)
  Location.destroy_all

  locations["locations"].each do |location|
    Location.create(:name => location["name"], :latitude => location["latitude"], :longitude => location["longitude"], :region_id => Region.find(location["region_id"]))
  end
end