module Currency
  USD_ISO = 'USD'.freeze

  USD_TO_DM_1993 = 1.66.freeze
  CPI_2017 = 244.786.freeze
  CPI_1993 = 144.5.freeze

  CAD_TO_USD = 0.75.freeze

  def self.converted_value(input_value, currency_iso)
    usd_amount(input_value, currency_iso) * dm_amount
  end

  private

  def self.dm_amount
    (CPI_1993 / CPI_2017) * USD_TO_DM_1993
  end

  def self.usd_amount(input_value, currency_iso)
    currency_iso == USD_ISO ? input_value : input_value * rate
  end

  def self.rate
    return 1 if Rails.env.test?

    CAD_TO_USD
  end
end
