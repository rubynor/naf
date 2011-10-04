Fabricator :activity do
  summary "Activity"
  location_id {Fabricate(:location).id}
  category_id {Fabricate(:category).id}
end

Fabricator :location do
  name "NAF track Oslo"
  latitude 60.4
  longitude 3.4
end

Fabricator :category do
  name "Tracks"
end