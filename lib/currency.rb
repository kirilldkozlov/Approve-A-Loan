require 'open-uri'

class Currency
  attr_accessor :input_value, :currency_iso

  SERVICE_HOST = 'finance.google.com'.freeze
  SERVICE_PATH = '/finance/converter'.freeze
  USD_ISO = 'USD'.freeze

  USD_TO_DM_1993 = 1.66
  CPI_2017 = 244.786
  CPI_1993 = 144.5

  def initialize(input_value, currency_iso)
    @input_value = input_value
    @currency_iso = currency_iso
  end

  def converted_value
    dm_amount
  end

  private

  def dm_amount
    usd_amount * (CPI_1993 / CPI_2017) * USD_TO_DM_1993
  end

  def usd_amount
    @currency_iso == USD_ISO ? @input_value : @input_value * rate
  end

  def rate
    return 1 if Rails.env.test?

    rates = Rails.cache.fetch("rates-#{@currency_iso}", expires_in: 12.hours) do
      fetch_rates(@currency_iso)
    end

    extract_rate(rates)
  end

  def fetch_rates(iso)
    uri = URI::HTTP.build(
      host: SERVICE_HOST,
      path: SERVICE_PATH,
      query: "a=1&from=#{iso}&to=#{USD_ISO}"
    )

    uri.read
  end

  def extract_rate(rates)
    case rates
    when %r{<span class=bld>(\d+\.?\d*) [A-Z]{3}<\/span>}
      Regexp.last_match(1).to_f
    else
      raise StandardError, 'Rate Fetch Error'
    end
  end
end
