class ProfilesController < ApplicationController
  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    byebug
    respond_to do |format|
      if @profile.valid?
          format.html { render :view, notice: 'Profile was successfully created.' }
      else
          format.html { render :new }
      end
    end
  end

  def view
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
