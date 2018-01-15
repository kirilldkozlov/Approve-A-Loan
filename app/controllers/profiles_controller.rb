require "base64"

class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)

    if @profile.valid?
      data = Base64.urlsafe_encode64(@profile.testing_array.to_s) || ""
      redirect_to action: "index", data: data
    else
      render :new
    end
  end

  def index
    data = params[:data] || ""
    decoded_data =  Base64.urlsafe_decode64(data)

    @data = decoded_data
  end

  private

  def profile_params
    params.require(:profile).permit(
      :name,
      :currency,
      :age,
      :telephone,
      :relationship_and_sex,
      :property_status,
      :housing_status,
      :foreign_worker,
      :job_status,
      :employment_length,
      :loan_duration_months,
      :loan_purpose,
      :chequing_balance,
      :loan_amount,
      :other_debtors_guarantors,
      :credit_history,
      :other_loans,
      :value_of_savings
    )
  end
end
