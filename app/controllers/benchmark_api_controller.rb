require 'json'

class BenchmarkApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request


  def analyze_no_threads
    data = { jobs: [], logs: [] }
    logs = process_jobs(get_jobs(params[:profiles], data))

    if logs.empty?
      render json: {
        error: "Failed to analyze record(s)"
      }
    else
      render json: logs
    end
  end

  private

  def profile_params(params)
    params.permit(
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

  def get_jobs(queries, data)
    queries.each_with_index do |profile, index|
      prof = Profile.new(profile_params(profile))
      analysis = {id: index, process_date: Time.now, profile: prof}

      if prof.valid?
        data[:jobs].push(analysis)
      else
        analysis[:verdict] = "Invalid request"
        data[:logs].push(analysis)
      end
    end

    data
  end


  def process_jobs(data)
    analyzer = Analyzer.new

    data[:jobs].each do |job|
      prediction = analyzer.
        predict(job[:profile].testing_array)
      job[:verdict] = prediction.first.to_i == 1 ? 'approved' : 'denied'
      job[:confidence] = "#{(prediction.last.to_f * 100).round(2)}%"

      data[:logs].push(job)
    end


    data[:logs]
  end
end
