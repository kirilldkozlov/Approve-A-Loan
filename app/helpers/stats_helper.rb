module StatsHelper
  def self.sum_of_loans
    arr = Profile::APPROVED_CURRENCY.map do |cur|
      sum = Log.saved.where(currency: cur, verdict: 'approved').sum(:loan_amount)

      format('%0.2f', sum).to_s + ' ' + cur if sum > 0
    end

    arr.compact.to_sentence
  end
end
