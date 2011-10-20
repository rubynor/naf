# encoding: UTF-8
#
# create some activities
#
desc "Create activities in the database"
task :populate_activities => :environment do
  Activity.destroy_all
  100.times do |i|
    range = Activity.range_from_target(Activity.targets[rand(Activity.targets.size)])
    min_age = range[0]
    max_age = range[1]
    Activity.create(
      :summary => "Oppsummering aktivitet #{i}",
      :description => "Beskrivelse aktivitet #{i}",
      :contact => "Kontaktinfo for aktivitet #{i}",
      :attendee => "Bookinglink til aktivitet #{i}",
      :url => "http://www.naf.no/#aktivitet#{i}",
      :dtstart => Time.now+3.days,
      :dtend => Time.now + 5.days,
      :price => 500.0,
      :video => "http://youtu.be/T4yjrkdOxfw",
      :responsibility => "Bring helmet to aktivitet #{i}",
      :vehicle => Activity.veichles[rand(Activity.veichles.size)],
      :own_veichle => true,
      :supervisor_included => true,
      :category_id => Category.all[rand(Category.all.size)].id,
      :location_id => Location.all[rand(Location.all.size)].id,
      :organizer_id => Location.all[rand(Location.all.size)].id,
      :age_from => min_age,
      :age_to => max_age,
      :tags => "kurs, norge",
      :active => true
    )
  end
  Sunspot.commit
end

