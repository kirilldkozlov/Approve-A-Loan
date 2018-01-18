require 'test_helper'

class ApiUserTest < ActiveSupport::TestCase
  def setup
    @api_user = api_users(:one)
  end

  test 'valid user' do
    assert @api_user.valid?
  end

  test 'invalid without email' do
    @api_user.email = nil
    refute @api_user.valid?
    assert_not_nil @api_user.errors[:email]
  end

  test 'invalid without expiry' do
    @api_user.expiry = nil
    refute @api_user.valid?
    assert_not_nil @api_user.errors[:expiry]
  end

  test "doesn't allow a duplicate email" do
    dup_user = ApiUser.create(
      email: @api_user.email,
      password: 'test',
      expiry: ApiUser::EXPIRY_DATES[1][1]
    )

    refute dup_user.valid?
  end

  test 'allows a duplicate if the other is expired' do
    @api_user.expiry = 7.days.ago
    @api_user.save!

    dup_user = ApiUser.create(
      email: @api_user.email,
      password: 'test',
      expiry: ApiUser::EXPIRY_DATES[1][1]
    )

    assert dup_user.valid?
  end
end
