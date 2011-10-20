#lib/tasks/sunspot.rake
namespace :sunspot do
  desc "indexes searchable models"
  task :index => :environment do
    [Activity].each {|model| Sunspot.index!(model.all)}
  end
end
