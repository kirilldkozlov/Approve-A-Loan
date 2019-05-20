require 'test_helper'

class AnalyzerApiControllerTest < ActionDispatch::IntegrationTest
  setup do
    @log = logs(:saved)
  end

  test '#test returns the hello word' do
    get test_path

    assert_response :success
    assert JSON.parse(response.body)['text']
  end

  test '#logs returns an error if there is no matchs' do
    get logs_path(name: 'Not a name'), as: :json, xhr: true
    assert_response :success

    assert JSON.parse(response.body)['error']
  end

  test '#logs returns by a single first name' do
    get logs_path(name: names.first), as: :json, xhr: true
    assert_response :success

    assert_equal @log.name, JSON.parse(response.body).first['name']
  end

  test '#logs returns by a single last name' do
    get logs_path(name: names.last), as: :json, xhr: true
    assert_response :success

    assert_equal @log.name, JSON.parse(response.body).first['name']
  end

  test '#logs returns by 3 letters of first name' do
    get logs_path(name: names.first[0..2]), as: :json, xhr: true
    assert_response :success

    assert_equal @log.name, JSON.parse(response.body).first['name']
  end

  private

  def names
    first_name, last_name = @log.name.split
  end
end
