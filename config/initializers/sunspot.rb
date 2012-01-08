# -*- encoding : utf-8 -*-

if Rails.env.test? || Rails.env.development?
  #Sunspot.config.solr.url = 'http://0.0.0.0:8981/solr'
end

Sunspot.session = Sunspot::Rails.build_session
ActionController::Base.module_eval { include(Sunspot::Rails::RequestLifecycle) }
