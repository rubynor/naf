# encoding: UTF-8
#
# categories are hardcoded as a start
#
desc "Create categories in the database"
task :populate_categories => :environment do
  Category.destroy_all
  %w{Kurs/opplæring, NAF tester, Aksjoner og konkurranser, Seminar og foredrag, Politisk påvirkningsarbeid, Motorsport}.each do |cat|
    Category.create(:name => cat)
  end
end



