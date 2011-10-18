Fabricator :activity do
  summary "Activity"
  location_id {Fabricate(:location).id}
  category_id {Fabricate(:category).id}
  active true
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