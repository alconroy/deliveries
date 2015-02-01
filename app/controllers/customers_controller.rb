class CustomersController < ApplicationController
  before_action :require_admin
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  def index
    # check if any customer records have (0,0) coords => invalid,
    # flash an alert and these records will be marked in view too.
    if Customer.find_by(latitude: 0, longitude: 0)
      # order by latitude so invalid are at top
      @customers = Customer.order(:latitude)
      flash[:alert] = "Some customer records have invalid GPS location information." +
        "They need to be edited manually and are highlighted in red below"
    else
      @customers = Customer.all.order(:name)
    end
  end

  # GET /customers/1/edit
  def edit
  end

  # GET /customers/1
  def show
    @deliveries = Delivery.where(customer_id: @customer.id).order(date: :desc);
  end

  # PATCH/PUT /customers/1
  def update
    if @customer.update(customer_params)
      redirect_to customers_path, notice: 'Customer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /customers/1
  def destroy
    @customer.destroy
    redirect_to customers_url, notice: 'Customer was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:code, :name, :address, :postcode, :latitude, :longitude)
    end
end
