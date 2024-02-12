class User < ApplicationRecord
  has_secure_password

  has_many :registrations, dependent: :nullify

  before_create :set_default_role

  validates :username, presence: true, uniqueness: true, format: {
    with: /\A[a-zA-Z0-9_]+\z/, message: ": Only allow letters, numbers and underscores"
  }
  validates :password, presence: true, length: {minimum: 6}, format: {
    with: /\A(?=.*[A-Z])(?=.*[0-9])/,
    message: ": must contain at least one uppercase letter, one numeric digit, and be at least 6 characters long"
  }
  validates :full_name, presence: true, format: {
    with: /\A[a-zA-Z ]+\z/, message: ": Enter letters only"
  }
  validates :email, presence: true,  uniqueness: true, format: {
    with: /[\w+.-]+@[\w+.-]+/, message: ": Enter valid email"
  }
  
  private

  def set_default_role
    self.role ||= "user"
  end
end
