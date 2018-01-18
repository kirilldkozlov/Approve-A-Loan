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
    first_name = first_name.nil? ? "#{SecureRandom.base64}" : first_name
    last_name = last_name.nil? ? "#{SecureRandom.base64}" : last_name

    Log.saved.where(
      '(name= ?) OR
      (name like ?) OR
      (name like ?) OR
      (name like ?) OR
      (name like ?)',
      name,
      "%#{first_name}%",
      "%#{last_name}%",
      "#{first_name[0..2]}%",
      "#{last_name[0..2]}%"
    )
  end
end
