class Event < ApplicationRecord
  has_many :registrations

  validates :title, presence: true
  validates :publish_date, presence: true
  validates :time, presence: true
  validates :venue, presence: true
  validates :description, presence: true
end

