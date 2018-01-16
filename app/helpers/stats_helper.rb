module StatsHelper

  def self.sum_of_loans
    arr = Profile::APPROVED_CURRENCY.map do |cur|
      sum = Log.where(currency: cur, verdict: "approved").sum(:loan_amount)

      if sum > 0
        ("%0.2f" % sum).to_s + " " + cur
      end
    end

    arr.compact.to_sentence
  end
end
