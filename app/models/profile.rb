class Profile
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :name, :age, :telephone, :relationship_and_sex, :property_status
  attr_accessor :housing_status, :foreign_worker, :job_status
  attr_accessor :employment_length, :loan_duration_months, :loan_purpose
  attr_accessor :currency, :chequing_balance
  attr_accessor :loan_amount, :other_debtors_guarantors, :credit_history
  attr_accessor :other_loans, :value_of_savings

  validates :name, presence: true
  validates :currency, presence: true

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

  APPROVED_CURRENCY = %w[USD CAD EUR GBP JPY].freeze

  validates_inclusion_of :currency, in: APPROVED_CURRENCY

  before_validation :convert_to_int
  after_validation :calculate_values

  RELATIONSHIP_AND_SEX = [
    ['Male: Single', 3],
    ['Male: Married or Widowed', 4],
    ['Male: Divorced', 1],
    ['Female: Single', 5],
    ['Female: Married, Divorced or Widowed', 2]
  ].freeze

  PROPERTY_STATUS = [
    ['Own real estate', 1],
    ['Car ownership but no real estate', 3],
    ['No property or unknown', 4]
  ].freeze

  HOUSING_STATUS = [
    ['Rent', 1],
    ['Homeowner', 2],
    ['Free housing', 3]
  ].freeze

  JOB_STATUS = [
    ['Unemployed and Non-Resident', 1],
    ['Unemployed and Resident', 2],
    ['Employed', 3],
    ['Management position or Self-Employed', 4]
  ].freeze

  EMPLOYMENT_LENGTH = [
    ['Unemployed', 1],
    ['Less than a year', 2],
    ['1 to 4 years', 3],
    ['4 to 7 years', 4],
    ['More than 7 years', 5]
  ].freeze

  LOAN_PURPOSE = [
    ['New car', 0],
    ['Used car', 1],
    ['Furniture', 2],
    ['Television', 3],
    ['Home appliances', 4],
    ['Repairs', 5],
    ['Tuition', 6],
    ['Professional training', 8],
    ['Business loan', 9],
    ['General', 10]
  ].freeze

  OTHER_DEBTORS_GUARANTORS = [
    ['None', 1],
    ['Co-applicant', 2],
    ['Guarantor', 3]
  ].freeze

  CREDIT_HISTORY = [
    ['No outstanding credit', 0],
    ['Credit at this company paid back on schedule', 1],
    ['Other credit paid back on schedule', 2],
    ['Delay in paying back credit in the past', 3],
    ['Significant outstanding credit', 4]
  ].freeze

  OTHER_LOANS = [
    ['Bank loans', 1],
    ['Loans from a company/store', 2],
    ['None', 3]
  ].freeze

  def testing_array
    [
      @chequing_balance,
      @loan_duration_months,
      @credit_history,
      @loan_purpose,
      @loan_amount,
      @value_of_savings,
      @employment_length,
      @relationship_and_sex,
      @other_debtors_guarantors,
      @property_status,
      @age,
      @other_loans,
      @housing_status,
      @job_status,
      @telephone,
      @foreign_worker
    ]
  end

  private

  def convert_to_int
    self.age = age.to_i
    self.relationship_and_sex = relationship_and_sex.to_i
    self.property_status = property_status.to_i
    self.housing_status = housing_status.to_i
    self.job_status = job_status.to_i
    self.employment_length = employment_length.to_i
    self.loan_duration_months = loan_duration_months.to_i
    self.loan_purpose = loan_purpose.to_i
    self.chequing_balance = chequing_balance.to_i
    self.loan_amount = loan_amount.to_i
    self.other_debtors_guarantors = other_debtors_guarantors.to_i
    self.credit_history = credit_history.to_i
    self.other_loans = other_loans.to_i
    self.value_of_savings = value_of_savings.to_i

    self.telephone = @telephone.nil? ? 1 : 2
    self.foreign_worker = @foreign_worker ? 1 : 2
  end

  def calculate_values
    loan_amount_update
    classify_chequing_balance
    classify_value_of_savings
  end

  def update_value(amount)
    Currency.new(amount, currency).converted_value
  end

  def loan_amount_update
    self.loan_amount = update_value(@loan_amount)
  end

  def classify_chequing_balance
    dm_val = update_value(@chequing_balance)

    self.chequing_balance = if dm_val < 0
                              1
                            elsif dm_val >= 0 && dm_val < 200
                              2
                            elsif dm_val >= 200
                              3
    end
  end

  def classify_value_of_savings
    dm_val = update_value(@value_of_savings)

    self.value_of_savings = if dm_val.zero?
                              5
                            elsif dm_val > 0 && dm_val < 100
                              1
                            elsif dm_val >= 100 && dm_val < 500
                              2
                            elsif dm_val >= 500 && dm_val < 1000
                              3
                            elsif dm_val >= 1000
                              4
    end
  end
end
