# -*- encoding : utf-8 -*-
class InternalInformation
  include Mongoid::Document
  field :volunteers_count, type: Integer
  field :volunteers_hours, type: Integer
  field :retrospect_good, type: String
  field :retrospect_improve, type: String
  field :competence, type: String
  field :participants_count, type: Integer
  embedded_in :activity
end
