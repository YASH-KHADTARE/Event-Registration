class Event < ApplicationRecord
  has_many :registrations

  validates :title, presence: true
  validates :publish_date, presence: true, format:{
    with: /\d{4}-\d{2}-\d{2}/,message: "Enter date in valid format YYYY-MM-DD"
  }
  validates :time, presence: true
  validates :venue, presence: true
  validates :description, presence: true
end

