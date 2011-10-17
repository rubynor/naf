task :post_test do
  res = RestClient.post "http://naf.herokuapp.com/activities", :activity => {:symmary => "hei"}

  ap res
end