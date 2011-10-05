source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'mongoid'
gem 'bson_ext'

gem 'sunspot_rails' #searching
gem 'sunspot_mongoid' #for search in mongoid

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

group :test, :development do
  gem "rspec-rails", "~> 2.6"
  gem 'sunspot_solr'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'fabrication'
end
