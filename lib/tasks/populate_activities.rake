# encoding: UTF-8
#
# create some activities
#
desc "Create activities in the database"
task :populate_activities => :environment do
  @veichles = %w{Bil, Moped, Motorsykkel, Tungt kjøretøy, ATV, Buss, Sykkel}
  Activity.destroy_all
  10.times do |i|
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
    :veichle => @veichles[rand(@veichles.size)],
    :own_veichle => true,
    :supervisor_included => true,
    :category_id => Category.all[rand(Category.all.size)].id,
    :location_id => Location.all[rand(Location.all.size)].id,
    :tags => "kurs, norge"
  )
  end
end

