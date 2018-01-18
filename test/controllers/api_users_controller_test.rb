require 'test_helper'

class ApiUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_user = api_users(:one)
  end

  test '#new renders the form' do
    get new_api_user_path
    assert_select 'form'
  end

  test '#create returns to new if the ApiUser is invalid' do
    post api_users_path, params: bad_user_params

    assert_template 'new'
  end

  test '#create redirects to index and creates a ApiUser' do
    assert_difference 'ApiUser.count', 1 do
      post api_users_path, params: user_params
    end

    assert_redirected_to profiles_path
  end

  private

  def user_params
    {
      api_user: {
        email: 'test1@test.com',
        expiry: Time.zone.now + 7.days,
        password: 'password'
      }
    }
  end

  def bad_user_params
    {
      api_user: {
        email: @api_user.email,
        expiry: Time.zone.now + 7.days,
        password: 'password'
      }
    }
  end
end
