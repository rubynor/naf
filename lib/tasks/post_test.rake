task :post_test do
  res = RestClient.post "http://naf.herokuapp.com/activities", :activity => {:symmary => "hei", :location_id => "4e89af11381db80006000070"}

  ap res
end