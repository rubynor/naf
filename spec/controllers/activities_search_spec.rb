#
# All specs for search on activities (sunspot is turned of in activities controller specs - here it is not)
#

def json_decoded(input)
  ActiveSupport::JSON.decode(input)
end

def search_results_for(response)
  json_decoded(response.body)["activities"]
end



describe ActivitiesController do
  it "finds activities based on words in summary (this is real search)", :solr => true do
    get :search, :text => "dance"
    ActiveSupport::JSON.decode(response.body).should == {"activities" => []}
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle")
    Sunspot.commit
    get :search, :text => "dance"
    ActiveSupport::JSON.decode(response.body).should == ActiveSupport::JSON.decode({:activities => [activity]}.to_json)
  end
  
  it "finds activities based on words in description", :solr => true do
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle", :description => "great stuff")
    Sunspot.commit
    get :search, :text => "stuff"
    ActiveSupport::JSON.decode(response.body).should == ActiveSupport::JSON.decode({:activities => [activity]}.to_json)
  end
  
  it "finds activities based on an array of categories", :solr => true do
    category1 = Fabricate(:category)
    category2 = Fabricate(:category)
    category3 = Fabricate(:category)
    activity1 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle1",:category_id => category1.id)
    activity2 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle2", :category_id => category2.id)
    activity3 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle3", :category_id => category3.id)
    Sunspot.commit
    get :search, :text => "jungle1", :category_ids => ["#{category1.id}"]
    search_results_for(response).should == json_decoded([activity1].to_json)
  end
  
end