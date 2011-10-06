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
    search_results_for(response).should == json_decoded([].to_json)
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle")
    Sunspot.commit
    get :search, :text => "dance"
    search_results_for(response).should == json_decoded([activity].to_json)
  end
  
  it "finds activities based on words in description", :solr => true do
    activity = Fabricate(:activity, :summary => "Learn to slow dance in the jungle", :description => "great stuff")
    Sunspot.commit
    get :search, :text => "stuff"
    search_results_for(response).should == json_decoded([activity].to_json)
  end
  
  it "finds activities based on an array of categories", :solr => true do
    category1 = Fabricate(:category)
    category2 = Fabricate(:category)
    category3 = Fabricate(:category)
    activity1 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle1",:category_id => category1.id)
    activity2 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle2", :category_id => category2.id)
    activity3 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle3", :category_id => category3.id)
    Sunspot.commit
    
    get :search, :text => "jungle1", :category_ids => ["bogus"]
    search_results_for(response).should == json_decoded([].to_json)
    
    get :search, :text => "jungle1", :category_ids => ["#{category1.id}"]
    search_results_for(response).should == json_decoded([activity1].to_json)
    
    get :search, :text => "", :category_ids => ["#{category1.id}"]
    search_results_for(response).should == json_decoded([activity1].to_json)
    
    get :search, :text => "", :category_ids => ["#{category1.id}", "#{category2.id}"]
    search_results_for(response).should == json_decoded([activity1, activity2].to_json)
    
    get :search, :text => "jungle2", :category_ids => ["#{category1.id}", "#{category2.id}"]
    search_results_for(response).should == json_decoded([activity2].to_json)
  end
  
  it "finds activities based on target audience", :solr => true do
    activity1 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle1",:target => "Barn 0 - 14")
    activity2 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle2", :target => "Voksne 25 - 40")
    activity3 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle3", :target => "Eldre 65 +")
    Sunspot.commit
    get :search, :text => "no match", :target => []
    search_results_for(response).should == json_decoded([].to_json)
    get :search, :text => "", :target => ["Barn 0 - 14"]
    search_results_for(response).should == json_decoded([activity1].to_json)
    get :search, :text => "", :target => ["Barn 0 - 14", "Voksne 25 - 40"]
    search_results_for(response).should == json_decoded([activity1, activity2].to_json)
  end
  
  it "finds activities based on tags", :solr => true do
    activity1 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle1",:tags=> "tag1")
    activity2 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle2", :tags => "tag1, tag2")
    Sunspot.commit
    get :search, :text => "tag1"
    search_results_for(response).should == json_decoded([activity1, activity2].to_json)
    get :search, :text => "tag2"
    search_results_for(response).should == json_decoded([activity2].to_json)
  end
  
  it "finds activities based on veichles", :solr => true do
    activity1 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle1",:vehicle => "MC")
    activity2 = Fabricate(:activity, :summary => "Learn to slow dance in the jungle2", :vehicle => "sykkel")
    Sunspot.commit
    get :search, :text => "mc"
    search_results_for(response).should == json_decoded([activity1].to_json)
    get :search, :text => "sykkel"
    search_results_for(response).should == json_decoded([activity2].to_json)
  end
  
end