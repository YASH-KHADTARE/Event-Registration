class User < ApplicationRecord
  has_secure_password

  has_many :registrations, dependent: :nullify

  before_create :set_default_role

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true,  uniqueness: true
  
  private

  def set_default_role
    self.role ||= "user"
  end

end
