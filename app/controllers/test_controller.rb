# -*- encoding : utf-8 -*-
#
# used for testing some view stuff to help out Espen
#
class TestController < ApplicationController
  layout 'application'
  def index
    @activities = Activity.active
    @categories = Category.all
    @regions = Region.all
  end

end
