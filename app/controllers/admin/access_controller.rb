#
# gives access details to the activities admin interface in therms of what locations a user can manage
#

class Admin::AccessController < ApplicationController

  def index
    unless current_user
      render :nothing => true
    else
      if current_user.is_super_admin?
        render :json => "super"
      else
        render :json => current_user.editable_locations
      end
    end
  end

  #used during testing
  def fake_access
    result = []

  end

end