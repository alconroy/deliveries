class HomeController < ApplicationController

  def index
    # set variable to determine if map should show locations of all users
    @view_all = false
    if current_user.admin
      @view_all = true
    end
  end

end
