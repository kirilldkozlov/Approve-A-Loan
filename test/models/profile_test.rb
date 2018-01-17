require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @profile = Profile.new(
      name: "Kirill Kozlov",
      age: 19,
      telephone: "(647) 770 - 9188",
      relationship_and_sex: 1,
      property_status: 1,
      housing_status: 1,
      foreign_worker: 1,
      job_status: 1,
      employment_length: 12,
      loan_duration_months: 2,
      loan_purpose: 1,
      currency: "CAD",
      chequing_balance: 500,
      loan_amount: 100,
      other_debtors_guarantors: 1,
      credit_history: 2,
      other_loans: 1,
      value_of_savings: 1000
    )
  end

  test 'profile log' do
    assert @profile.valid?
  end

  test 'invalid without name' do
    @profile.name = nil
    refute @profile.valid?
    assert_not_nil @profile.errors[:name]
  end

  test 'invalid without a properly formatted telephone' do
    @profile.telephone = "647 770 9188"
    refute @profile.valid?
    assert_not_nil @profile.errors[:telephone]
  end

  test '#testing_array returns a complete array of valid length' do
    assert_equal 15, @profile.testing_array.compact.length
  end

  test '#max_condition? returns true when a loan meets the condition' do
    @profile.loan_amount = 35000
    assert @profile.max_condition?

    @profile.loan_duration_months = 61
    assert @profile.max_condition?
  end

  test '#testing_array correctly converts foreign_worker' do
    @profile.foreign_worker = 1
    assert_equal 2, @profile.testing_array.last
  end
end
