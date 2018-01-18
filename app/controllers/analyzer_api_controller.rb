class AnalyzerApiController < ApplicationController
  before_action :authenticate_request

  def test
    render json: { text: "Hello world!" }
  end
end
