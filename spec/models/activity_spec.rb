# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Activity do
  disconnect_sunspot

  it "should embed a location" do
    relation = Activity.relations['location']
    relation.klass.should == (EmbeddedLocation)
    relation.relation.should == (Mongoid::Relations::Embedded::One)
  end

  it "should embed a location as organizer" do
    relation = Activity.relations['organizer']
    relation.klass.should == (EmbeddedOrganizer)
    relation.relation.should == (Mongoid::Relations::Embedded::One)
  end

  it "should embedd the location upon creation" do
    activity = Fabricate(:activity)
    activity.location.name.should == "NAF track Oslo"
  end

  it "should embed internal_information - interninformasjon" do
    ii = Fabricate(:activity).internal_information
    ii.volunteers_count.should == 5
    ii.volunteers_hours.should == 43
    ii.competence.should == "Kompetanse på bil"
    ii.participants_count.should == 39
    ii.retrospect_good.should == "godt testede biler"
    ii.retrospect_improve.should == "må ha nok kaffe!"

  end

  it "should belongs to a" do
    relation = Activity.relations['category']
    relation.klass.should == (Category)
    relation.relation.should == Mongoid::Relations::Referenced::In
  end

  it "should embedd the category upon creation" do
    activity = Fabricate(:activity)
    activity.category.name.should == "Tracks"
  end

  it "should embedd the organizer if organizer id is set" do
    activity = Fabricate(:activity)
    location = Fabricate(:location, :name => "hello")
    activity.update_attributes(:organizer_id => location.id)
    activity.organizer.name.should == "hello"
  end

  it "can find range based on many targets" do
    Activity.total_range_for_targets(['Barn 0 - 14']).should == [0, 14]
    Activity.total_range_for_targets(['Barn 0 - 14', 'Ung 15 - 24']).should == [0, 24]
    Activity.total_range_for_targets(['Barn 0 - 14', 'Ung 15 - 24', 'Voksen 25 - 65']).should == [0, 65]
    Activity.total_range_for_targets(['Barn 0 - 14', 'Ung 15 - 24', 'Voksen 25 - 65', 'Eldre 65 +']).should == [0, 100]
    Activity.total_range_for_targets(['Ung 15 - 24', 'Voksen 25 - 65', 'Eldre 65 +']).should == [15, 100]
    Activity.total_range_for_targets(['Voksen 25 - 65', 'Eldre 65 +']).should == [25, 100]
    Activity.total_range_for_targets(['Eldre 65 +']).should == [65, 100]
  end

  it "sets dtend automatically if duration and dtstart is set"

end
