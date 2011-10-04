# encoding: UTF-8
#
# categories are hardcoded as a start
#
desc "Create categories in the database"
task :populate_categories => :environment do
  ['Lokalavdeling', 'NAF motorsport', 'NAF MC', 'Øvingsbane', 'Motorsportbane', 'Trafikksenter', 'Enhet/Avdeling(sentral)'].each do |cat|
    old_category = Category.where(:name => cat).first
    unless old_category
      Category.create(:name => cat)
    end
  end
end

