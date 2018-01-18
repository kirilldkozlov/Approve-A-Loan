require 'json'

class AnalyzerApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request

  def exact_log
    log = Log.saved.where(name: params[:name]).order(created_at: :desc).first

    if log.nil?
      render json: {
        error: "No records found for query with name: #{params[:name]}"
      }
    else
      render json: log
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

  def build_logs(name)
    first_name, last_name = name.split

    logs = if name
      Log.saved.where(name: name) + first(first_name) + last(last_name)
    else
      []
    end
  end

  def first(first_name)
    if first_name
      Log.saved.where('name like ?', "%#{first_name}%") +
        Log.saved.where('name like ?', "#{first_name[0..2]}%")
    else
      []
    end
  end

  def last(last_name)
    if last_name
      Log.saved.where('name like ?', "%#{last_name}%") +
        Log.saved.where('name like ?', "#{last_name[0..2]}%")
    else
      []
    end
  end
end
