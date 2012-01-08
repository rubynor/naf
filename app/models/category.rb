# -*- encoding : utf-8 -*-
class Category
  include Mongoid::Document
  field :name, :type => String
end
