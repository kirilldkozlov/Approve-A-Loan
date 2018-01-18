class ApiUser < ApplicationRecord
  has_secure_password

  # curl -H "Content-Type: application/json" -X POST -d '{"email":"email","password":"password"}' http://localhost:3000/authenticate
  # curl -H "Authorization: token" http://localhost:3000/test
  # eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo3LCJleHAiOjE1MTYzMzMwOTR9.8xueN-uhLyQQ0EilZBmnZitzVUGnlwtw818QvXCnYyw

  validates :email, presence: true
  validates :expiry, presence: true
  validates_uniqueness_of :email, unless: :previous_has_expired

  EXPIRY_DATES = [
    ["1 day", Time.zone.now + 1.day],
    ["2 days", Time.zone.now + 2.days],
    ["1 week", Time.zone.now + 1.week],
    ["1 month", Time.zone.now + 1.month]
  ]

  def expired?
    self.expiry < Time.zone.now
  end

  private

  def previous_has_expired
    return true unless ApiUser.exists?(email: self.email)
    ApiUser.find_by(email: self.email)&.expired?
  end
end
