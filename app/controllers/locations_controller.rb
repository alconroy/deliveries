class LocationsController < ApplicationController

  def index
    # list only for admin
    require_admin
    # get all locations received today
    @locations = Location.where(
      time: Time.now.midnight..(Time.now.midnight + 1.day))
  end

  def latest
    @locations = Location.latest_by_users
  end

  def update
    # don't want admin to update his own postion
    if !current_user.admin
      loc_hash = location_params      
      loc_hash[:user] = current_user
      @location = Location.new(loc_hash)
      # clean out old locations
      Location.remove_old
      # try and save new location
      if @location.save
        render json: '{ "status": "saved successfully" }'
      else
        render json: '{ "error": "location not saved" }'
      end
    else
      render json: '{ "status": "admin not able to update locations" }'
    end
  end

  private
    def location_params
      params.require(:location).permit(:user_id, :time, :latitude, :longitude)
    end
end
