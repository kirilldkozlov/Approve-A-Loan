require 'test_helper'

class LogTest < ActiveSupport::TestCase
  def setup
    @log = logs(:valid)
  end

  test 'valid log' do
    assert @log.valid?
  end

  test 'invalid without name' do
    @log.name = nil
    refute @log.valid?
    assert_not_nil @log.errors[:name]
  end

  test 'invalid without telephone' do
    @log.phone = nil
    refute @log.valid?
    assert_not_nil @log.errors[:phone]
  end

  test 'invalid without currency' do
    @log.currency = nil
    refute @log.valid?
    assert_not_nil @log.errors[:currency]
  end

  test 'invalid without loan_duration_months' do
    @log.loan_duration_months = nil
    refute @log.valid?
    assert_not_nil @log.errors[:loan_duration_months]
  end

  test 'invalid without loan_purpose' do
    @log.loan_purpose = nil
    refute @log.valid?
    assert_not_nil @log.errors[:loan_purpose]
  end

  test 'invalid without loan_amount' do
    @log.loan_amount = nil
    refute @log.valid?
    assert_not_nil @log.errors[:loan_amount]
  end

  test 'invalid without verdict' do
    @log.verdict = nil
    refute @log.valid?
    assert_not_nil @log.errors[:verdict]
  end
end
