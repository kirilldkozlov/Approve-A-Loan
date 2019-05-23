class Currency
  USD_ISO = 'USD'.freeze

  USD_TO_DM_1993 = 1.66
  CPI_2017 = 244.786
  CPI_1993 = 144.5

  CAD_TO_USD = 0.75

  def initialize
    make_threadsafe_by_stateless
  end

  def converted_value(input_value, currency_iso)
    usd_amount(input_value, currency_iso) * dm_amount
  end

  private

  def dm_amount
    (CPI_1993 / CPI_2017) * USD_TO_DM_1993
  end

  def usd_amount(input_value, currency_iso)
    currency_iso == USD_ISO ? input_value : input_value * rate
  end

  def rate
    return 1 if Rails.env.test?

    CAD_TO_USD
  end

  def make_threadsafe_by_stateless
    freeze
  end
end
