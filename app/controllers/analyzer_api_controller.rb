require 'json'
require 'thread'

class AnalyzerApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request

  POOL_SIZE = 10

  def analyze
    queries = params[:profiles]
    jobs = Queue.new
    analyzer = Analyzer.new
    logs = []

    queries.each_with_index do |profile, index|
      prof = Profile.new(profile_params(profile))
      analysis = {id: index, process_date: Time.now, profile: prof}

      if prof.valid?
        jobs.push(analysis)
      else
        analysis[:verdict] = "Invalid request"
        logs.push(analysis)
      end
    end

    num_of_workers = [queries.length, POOL_SIZE].min
    analyzers = (num_of_workers).times.map do
      analyzer.dup
    end

    # Run each through Analyzer
    workers = (num_of_workers).times.map do |worker|
      Thread.new do
        begin
          while analysis = jobs.pop(true)
            prediction = analyzers[worker].predict(analysis[:profile].testing_array)
            analysis[:verdict] = prediction.first.to_i == 1 ? 'approved' : 'denied'
            analysis[:confidence] = prediction.last
            logs.push(analysis)
          end
        rescue ThreadError
        end
      end
    end

    workers.map(&:join)

    logs = logs.sort_by { |log| log[:id].to_i }

    if logs.empty?
      render json: {
        error: "Failed to analyze record(s)"
      }
    else
      render json: logs
    end
  end

  def logs
    logs = build_logs(params[:name])

    if logs.empty?
      render json: {
        error: "No records found for query containing: #{params[:name]}"
      }
    else
      render json: logs
    end
  end

  def test
    render json: { text: 'Hello world! This is Approve-A-Loan :)' }
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

  def build_logs(name)
    logs = if name
             Log.saved.where('name = ? OR name like ? OR name like ?',
               name,
               "%#{name}%",
               "%#{name[0..2]}%")
           else
             []
    end
  end
end
