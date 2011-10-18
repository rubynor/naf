#
# put each location into the right region
#

task :populate_locations, :environment do
  locations = JSON.parse(File.open("#{Rails.root}/lib/tasks/locations.json").read)
  ap locations
  Location.destroy_all
  locations = JSON.parse(locations)
  locations.each do |location|
    Location.create(:name => location.name, :latitude => location.latitude, :longitude => location.longitude, :region => Region.find(location.region_id))
  end
end