require 'base64'
require 'sidekiq/api'

class ProfilesController < ApplicationController
  skip_before_action :authenticate_request

  def new
    ConstructTreeWorker.perform_async
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)

    begin
      if @profile.valid?
        wait_for_sidekiq
        create_analysis
      else
        render :new
      end
    rescue StandardError
      redirect_to profiles_path, flash: {
        error: "Connection error. Please try again later."
      }
    end
  end

  def analysis
    log_id = decoder(params[:log_id])
    @confidence = decoder(params[:confidence])
    @log = Log.find_by_id(log_id)
  end

  def delete
    Log.find_by_id(params[:id].to_i)&.destroy
    redirect_to profiles_path
  end

  def print
    @log = Log.find_by_id(params[:id].to_i)
    render layout: false
  end

  def save
    Log.find_by_id(params[:id].to_i)&.update_attributes!(status: 1)
    redirect_to profiles_path, flash: {
      saved: "Analysis saved!"
    }
  end

  def index
    Log.where(status: 0).destroy_all
    @logs = Log.where(status: 1)
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

  def prediction(profile)
    if profile.max_condition?
      [2, 1]
    elsif Rails.env.test?
      [1, 1]
    else
      Analyzer.new.predict(profile.testing_array)
    end
  end

  def create_analysis
    verdict, confidence = prediction = prediction(@profile)
    loan_amount = profile_params[:loan_amount]
    log_id = save_log(@profile, loan_amount, verdict)

    redirect_to action: 'analysis',
                log_id: encoder(log_id),
                confidence: encoder(confidence)
  end

  def save_log(profile, loan_amount, verdict)
    log = Log.create!(
      name: profile.name,
      phone: profile.telephone,
      currency: profile.currency,
      loan_duration_months: profile.loan_duration_months.to_i,
      loan_purpose: Profile::LOAN_PURPOSE.select{ |key, val| val == profile.loan_purpose.to_i }.first.first,
      loan_amount: loan_amount,
      verdict: verdict.to_i
    )

    log.id
  end

  def encoder(val)
    Base64.urlsafe_encode64(val.to_s || '')
  end

  def decoder(val)
    Base64.urlsafe_decode64(val || '')
  end

  def wait_for_sidekiq
    sleep(1) until Sidekiq::Workers.new.size == 0 && Sidekiq::Queue.new.size == 0
    return true
  end
end
