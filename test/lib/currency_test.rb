require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  test "#converted_value returns a valid conversion with exchange rate 1" do
    currency = Currency.new(100, "CAD")

    assert_includes 97..98, currency.converted_value
  end
end
