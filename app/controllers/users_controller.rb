class UsersController < ApplicationController
  before_action :require_admin

  # GET /admin/users
  def index
  	@users = User.all
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
    set_user
    @self_edit = false
    if @user == current_user
      @self_edit = true
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_url, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    set_user
    if @user.update_attributes(user_params)
      redirect_to users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/users/1
  def destroy
    set_user
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :admin, :van)
    end

end
