class Log < ApplicationRecord
  validates :name, presence: true
  validates :phone, presence: true
  validates :currency, presence: true
  validates :loan_duration_months, presence: true
  validates :loan_purpose, presence: true
  validates :loan_amount, presence: true
  validates :verdict, presence: true

  enum verdict: { approved: 1, denied: 2 }
  enum status: [ :generated, :saved ]
end
