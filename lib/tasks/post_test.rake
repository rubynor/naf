task :post_test do
  res = RestClient.post "http://naf.herokuapp.com/activities", :activity => {:summary => "Test", :organizer_id => "4e9d689a05e3370005000076"}, :content_type => 'image/jpg'

  ap res
end