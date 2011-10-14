#
# used for testing some view stuff to help out Espen
#
class TestController < ApplicationController
  layout 'application'
  def index
    @activities = Activity.all
    @categories = Category.all
  end

end