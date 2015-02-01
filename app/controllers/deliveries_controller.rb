class DeliveriesController < ApplicationController
  before_action :set_delivery, only: [:update]

  # GET /deliveries
  # GET /deliveries.json
  def index
    # for an admin user, return all todays deliveries
    if current_user.admin
      @deliveries = {}
      # create a hash keyed by users => deliveries
      User.all.each do |u|
        ds = u.deliveries.where(date: Date.today).order(:precedence, :complete)
        @deliveries[u] = ds unless ds.length == 0
      end
    else
      # for normal user, return only their deliveries for today
      @deliveries = Delivery.where(user: current_user, date: Date.today)
        .order(:precedence, :complete)
    end
  end

  # GET /deliveries/calc
  def calc
    # don't allow admin to recalc
    if !current_user.admin
      Delivery.calculate(current_user)
      redirect_to root_path
    end
  end

  # GET /deliveries/user/:id
  def user
    # return deliveries for a specific user (only for admin)
    if current_user.admin
      user = User.find(params[:id])
      @deliveries = Delivery.where(user: user, date: Date.today)
        .order(:precedence, :complete)
      render :index
    else
      redirect_to deliveries_path
    end
  end

  # PATCH/PUT /deliveries/1
  def update
      if @delivery.update(delivery_params)
        if !current_user.admin
          Delivery.calculate(current_user)
        end
        redirect_to root_path
      else
        redirect_to deliveries_path, alert: "Error Completing that Action"
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_params
      params.require(:delivery).permit(:user_id, :customer_id, :date, :precedence, :complete, :travel_time)
    end
end
