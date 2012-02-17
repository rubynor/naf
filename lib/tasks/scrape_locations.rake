# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'restclient'


#
# gets location from NAF and store them as locations in the DB
#
desc "Get the location from NAF site"
task :scrape_locations => :environment do
  Location.scrape
end
