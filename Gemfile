source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'mongoid'
gem 'bson_ext'
gem 'kaminari' #for pagination
gem "sunspot"
gem "sunspot_rails"
gem "sunspot_mongoid"
gem 'devise'
gem 'fog'
gem 'carrierwave', '~> 0.5.3'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'rmagick', "~> 2.13.1", :require => 'RMagick'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

gem 'nokogiri'
gem 'rest-client'
gem 'awesome_print'

group :production do
  gem 'newrelic_rpm'
end

group :test, :development do
  gem "rspec-rails", "~> 2.6"

  #Should spend:
    #sunspot (1.2.1)
    #sunspot_mongo (1.0.1)
    #sunspot_mongoid (0.4.1)
    #sunspot_rails (1.2.1)
    #sunspot_solr (1.3.0.rc4)
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'fabrication'
end
