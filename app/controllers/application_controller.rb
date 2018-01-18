class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    @current_user = if Rails.env.test?
      ApiUser.create(email: "test@test.com", expiry: Time.zone.now + 1.day, password: 'password')
    else
      AuthorizeApiRequest.call(request.headers).result
    end

    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
