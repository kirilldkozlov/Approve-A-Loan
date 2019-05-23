require 'json'
require 'thread'

class AnalyzerApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request

  POOL_SIZE = 10

  def analyze
    data = { jobs: Queue.new, logs: [] }
    logs = process_jobs(get_jobs(params[:profiles], data)).
      sort_by { |log| log[:id].to_i }

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

  def get_jobs(queries, data)
    queries.each_with_index do |profile, index|
      profile = profile_params(profile).to_hash
      validation = QuickProfile.validate(profile)
      analysis = {id: index, process_date: Time.now, profile: profile}

      if validation[:result]
        data[:jobs].push(analysis)
      else
        analysis[:verdict] = validation[:message]
        data[:logs].push(analysis)
      end
    end

    data
  end

  def process_jobs(data)
    lock = Mutex.new

    num_of_workers = [data[:jobs].length, POOL_SIZE].min
    analyzers = get_analyzers(num_of_workers)

    workers = (num_of_workers).times.map do |worker|
      Thread.new do
        begin
          while analysis = data[:jobs].pop(true)
            prediction = analyzers[worker].
              predict(QuickProfile.to_test_array(analysis[:profile]))
            analysis[:verdict] = prediction.first.to_i == 1 ? 'approved' : 'denied'
            analysis[:confidence] = "#{(prediction.last.to_f * 100).round(2)}%"

            lock.synchronize {
              data[:logs].push(analysis)
            }
          end
        rescue ThreadError
        end
      end
    end

    workers.map(&:join)

    data[:logs]
  end

  def get_analyzers(num_of_workers)
    analyzer = Analyzer.new

    analyzers = (num_of_workers).times.map do
      analyzer.dup
    end

    analyzers
  end
end
