require 'json'

class AnalyzerApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request

  def analyze
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
