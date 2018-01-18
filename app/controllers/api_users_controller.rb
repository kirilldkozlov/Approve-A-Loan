class ApiUsersController < ApplicationController
  skip_before_action :authenticate_request

  def new
    @user = ApiUser.new
  end

  def create
    @user = ApiUser.new(api_user_params)

    if @user.valid?
      @user.save!
      redirect_to profiles_path
    else
      render :new
    end
  end

  private

  def api_user_params
    params.require(:api_user).permit(
      :email,
      :expiry,
      :password
    )
  end
end
