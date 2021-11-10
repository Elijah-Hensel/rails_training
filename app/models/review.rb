class Review < ApplicationRecord
  belongs_to :movie

  STARS = Array(1..5)

  validates :name, presence: true
  validates :comment, length: { minimum: 4 }
  validates :stars, inclusion: { in: STARS, message: 'must be between 1 and 5' }

  def stars_as_percent
    (stars / 5.0) * 100.0
  end
end