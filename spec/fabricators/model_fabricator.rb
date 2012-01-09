# -*- encoding : utf-8 -*-
Fabricator :activity do
  summary "Activity"
  location_id {Fabricate(:location).id}
  organizer_id {Fabricate(:location).id}
  category_id {Fabricate(:category).id}

  internal_information { |activity| Fabricate.build(:internal_information, :activity => activity) }

  dtstart Time.now
  dtend Time.now + 3.days
  active true
end

Fabricator :internal_information do
  volunteers_count 5
  volunteers_hours 43
  retrospect_good "godt testede biler"
  retrospect_improve "må ha nok kaffe!"
  competence "Kompetanse på bil"
  participants_count 39
end

Fabricator :location do
  name "NAF track Oslo"
  latitude 60.4
  longitude 3.4
  region {Fabricate(:region) }
end

Fabricator :category do
  name "Tracks"
end

Fabricator :region do
  name "Nord"
end

Fabricator :user do
  email { Fabricate.sequence(:email) { |i| "user#{i}@rubynor.no" } }
  password "secret"
  password_confirmation "secret"
  location {Fabricate(:location)}
end
