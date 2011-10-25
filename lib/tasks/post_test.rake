task :post_test do
  res = RestClient.post "http://naf.herokuapp.com/activities", :activity => {:organizer_id => "4e9d689a05e3370005000076"}

  ap res.inspect
end