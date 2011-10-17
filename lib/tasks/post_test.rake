task :post_test do
  res = RestClient.post "http://naf.herokuapp.com/activities", :activity => {:symmary => "hei", :location_id => "4e89af11381db80006000001", :category_id => "4e8c42014eea890006000001"}

  ap res
end