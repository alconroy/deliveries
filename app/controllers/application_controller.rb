class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Can't do anything until sign in
  before_action :authenticate_user!

  # Set a user variable for nav bar partial
  before_action :set_users

  # When non admin user signs in, (re)calculate route
  def after_sign_in_path_for(resource)
    # for a non admin user recalc route and show map
    if resource.is_a?(User) && !resource.admin
      Delivery.calculate(resource)
    end
    root_path
  end

  protected

    # Utility function to enforce admin only access.
    def require_admin
      unless user_signed_in? && current_user.admin
        flash[:alert] = "Unauthorized access detected."
        redirect_to root_path
        false
      end
    end

    def set_users
      @nav_users = User.where(admin: false)
    end
end
