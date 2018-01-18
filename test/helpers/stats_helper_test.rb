require 'test_helper'

class StatsHelperTest < ActiveSupport::TestCase
  test '#sum_of_loans returns the correct string' do
    assert_equal '1000.00 CAD', StatsHelper.sum_of_loans
  end
end
