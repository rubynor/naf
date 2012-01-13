# -*- encoding : utf-8 -*-
class PoliticalActivity
  include Mongoid::Document
  field :contact_with, type: String
  embedded_in :activity
end
