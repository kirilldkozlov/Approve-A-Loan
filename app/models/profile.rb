class Profile < ActiveModel::Model
  attr_accessor :name, :age, :telephone, :relationship_and_sex, :property_status
  attr_accessor :housing_status, :foreign_worker, :job_status, :employment_length
  attr_accessor :loan_duration_months, :loan_purpose, :currency, :chequing_balance
  attr_accessor :loan_amount, :other_debtors_guarantors, :credit_history
  attr_accessor :other_loans, :value_of_savings

  validates :name, presence: true
  validates :currency, presence: true
  validates_inclusion_of :currency, :in => APPROVED_CURRENCY

  validates :age, numericality: true, presence: true
  validates :telephone, numericality: true, presence: true
  validates :relationship_and_sex, numericality: true, presence: true
  validates :property_status, numericality: true, presence: true
  validates :housing_status, numericality: true, presence: true
  validates :foreign_worker, numericality: true, presence: true
  validates :job_status, numericality: true, presence: true
  validates :employment_length, numericality: true, presence: true
  validates :loan_duration_months, numericality: true, presence: true
  validates :loan_purpose, numericality: true, presence: true
  validates :chequing_balance, numericality: true, presence: true
  validates :loan_amount, numericality: true, presence: true
  validates :other_debtors_guarantors, numericality: true, presence: true
  validates :credit_history, numericality: true, presence: true
  validates :other_loans, numericality: true, presence: true
  validates :value_of_savings, numericality: true, presence: true

  after_validations :calculate_values

  APPROVED_CURRENCY = ["USD", "CAD", "EUR", "GBP", "JPY"]

  RELATIONSHIP_AND_SEX = [
    ["Male: Single", 3],
    ["Male: Married or Widowed", 4],
    ["Male: Divorced", 1],
    ["Female: Single", 5],
    ["Female: Married, Divorced or Widowed", 2]
  ]

  PROPERTY_STATUS = [
    ["Own real estate", 1],
    ["Car ownership but no real estate", 3],
    ["No property or unknown", 4]
  ]

  HOUSING_STATUS = [
    ["Rent", 1],
    ["Homeowner", 2],
    ["Free housing", 3]
  ]

  JOB_STATUS = [
    ["Unemployed and Non-Resident", 1],
    ["Unemployed and Resident", 2],
    ["Employed", 3],
    ["Management position or Self-Employed", 4]
  ]

  EMPLOYMENT_LENGTH = [
    ["Unemployed", 1],
    ["Less than a year", 2],
    ["1 to 4 years", 3],
    ["4 to 7 years", 4],
    ["More than 7 years", 5]
  ]

  LOAN_PURPOSE = [
    ["New car", 0],
    ["Used car", 1],
    ["Furniture", 2],
    ["Television", 3],
    ["Home appliances", 4],
    ["Repairs", 5],
    ["Tuition", 6],
    ["Professional training", 8],
    ["Business loan", 9],
    ["Other", 10]
  ]

  OTHER_DEBTORS_GUARANTORS = [
    ["None", 1],
    ["Co-applicant", 2],
    ["Guarantor", 3]
  ]

  CREDIT_HISTORY = [
    ["No outstanding credit", 0],
    ["Credit at this company paid back on schedule", 1],
    ["Other credit paid back on schedule", 2],
    ["Delay in paying back credit in the past", 3],
    ["Significant outstanding credit", 4]
  ]

  OTHER_LOANS = [
    ["Bank loans", 1],
    ["Loans from a company/store", 2],
    ["None", 3]
  ]

  def telephone=(val)
    if val.nil?
      1
    else
      2
    end
  end

  def foreign_worker=(val)
    if val
      1
    else
      2
    end
  end

  private

  def calculate_values
    loan_amount_update
    classify_chequing_balance
    classify_value_of_savings
  end

  def update_value(amount, iso = currency)
    Currency.new(iso, amount).converted_value
  end

  def loan_amount_update
    loan_amount =  update_value(amount)
  end

  def classify_chequing_balance
    dm_val = update_value(chequing_balance)

    chequing_balance = if val < 0
      1
    elsif val >= 0 && val < 200
      2
    elsif val >= 200
      3
    end
  end

  def classify_value_of_savings
    dm_val = update_value(value_of_savings)

    value_of_savings = if val == 0
      5
    elsif val > 0 && val < 100
      1
    elsif val >= 100 && val < 500
      2
    elsif val >= 500 && val < 1000
      3
    elsif val >= 1000
      4
    end
  end
end

# # Personal info
# - Name (string)
# - Age 'Age in years' (int)
# - 'Telephone' (int)
# - 'Relationship status and sex' (enum)
#
# # Housing information
# 'Property ownership status',
# -  'Housing status',

# # Employment information
# - Foreign worker (boolean)
# - 'Job status' (enum)
# - 'Present employment length',

# # Loan Details
#   'Loan duration in months', x
#   'Purpose for loan', x
#   'Loan amount', x
#   'Other debtors/guarantors',x

# Financial Disclousre
  # 'Existing chequing balance', x
  # 'Value of savings',x
  # 'Credit history status', X
  # 'Other loans', X
