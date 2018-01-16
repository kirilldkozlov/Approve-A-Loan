require "base64"

class ProfilesController < ApplicationController
  def new
    ConstructTreeWorker.perform_async
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)

    if @profile.valid?
      prediction = Analyzer.new.predict(@profile.testing_array)
      verdict = prediction.first
      confidence = prediction.second
      telephone = profile_params[:telephone]
      purpose = @profile.loan_purpose
      name = @profile.name

      redirect_to action: "index",
        verdict: encoder(verdict),
        confidence: encoder(confidence),
        telephone: encoder(telephone),
        name: encoder(name),
        purpose: encoder(purpose)
    else
      render :new
    end
  end

  def index
    @verdict = decoder(params[:verdict])
    @confidence = decoder(params[:confidence])
    @name = decoder(params[:name])
    @telephone = decoder(params[:telephone])
    @purpose = Profile::LOAN_PURPOSE[decoder(params[:purpose]).to_i].first.downcase
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

  def encoder(val)
    Base64.urlsafe_encode64(val.to_s || "")
  end

  def decoder(val)
    Base64.urlsafe_decode64(val || "")
  end
end
