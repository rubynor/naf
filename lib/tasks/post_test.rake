task :post_test do
  res = RestClient.put "http://naf.herokuapp.com/activities/4e9c076bfa67c70001000002", :activity => {:symmary => ""}

  ap res
end