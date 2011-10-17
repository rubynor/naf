task :post_test do
  res = RestClient.put "http://naf.herokuapp.com/activities/4e955c5d31bd8a0006000008", :activity => {:symmary => "hei"}

  ap res
end