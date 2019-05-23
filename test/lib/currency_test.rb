require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  test '#converted_value returns a valid conversion with exchange rate 1' do
    assert_includes 97..98, Currency.converted_value(100, 'CAD')
  end
end
