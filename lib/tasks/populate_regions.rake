
desc "Create regions"
task :populate_regions => :environment do
  Activity.regions.each do |region|
    Region.find_or_create_by(:name => region)
  end
end