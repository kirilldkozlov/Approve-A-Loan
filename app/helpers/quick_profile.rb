module QuickProfile
  include Currency

  def self.validate(query)
    failures = []
    base = "Invalid request."

    if query.length != 18
      return { result: false, message: "#{base} Missing fields" }
    end

    query.each do |pair|
      unless valid_value(pair[0], pair[1])
        failures << pair[0].to_s
      end
    end

    unless failures.empty?
      return { result: false, message: "#{base} Validation failures: #{failures.to_s}" }
    end

    { result: true }
  end

  def self.to_test_array(profile)
    [
      profile["chequing_balance"],
      profile["loan_duration_months"],
      profile["credit_history"],
      profile["loan_purpose"],
      Currency.converted_value(profile["loan_amount"], profile[:currency]),
      profile["value_of_savings"],
      profile["employment_length"],
      profile["relationship_and_sex"],
      profile["other_debtors_guarantors"],
      profile["property_status"],
      profile["age"],
      profile["other_loans"],
      profile["housing_status"],
      profile["job_status"],
      profile["foreign_worker"] == 0 ? 1 : 2
    ]
  end

  private

  def self.valid_value(key, value)
    case key
    when "name"
      !value.nil?
    when "currency"
      %w[USD CAD].include?(value)
    when "age", "loan_duration_months", "loan_amount"
      value > 0
    when "telephone"
      /(\([0-9]{3}\)\s[0-9]{3}\s[-]\s[0-9]{4})+\z/.match?(value)
    when "relationship_and_sex", "employment_length"
      (1..5).include?(value)
    when "property_status"
      [1, 3, 4].include?(value)
    when "housing_status", "other_debtors_guarantors", "other_loans"
      (1..3).include?(value)
    when "job_status"
      (1..4).include?(value)
    when "foreign_worker"
      [0, 1].include?(value)
    when "loan_purpose"
      [0, 1, 2, 3, 4, 5, 6, 8, 9, 10].include?(value)
    when "chequing_balance", "value_of_savings"
      value >= 0
    when "credit_history"
      (0..4).include?(value)
    else
      false
    end
  end
end
