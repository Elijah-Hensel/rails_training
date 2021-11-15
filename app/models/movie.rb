class Movie < ApplicationRecord
  RATINGS = %w[G PG PG-13 R NC-17]

  before_save :set_slug

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :genre_joins, dependent: :destroy
  has_many :genres, through: :genre_joins

  validates :title, presence: true, uniqueness: true
  validates :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_that_or_equal_to: 0 }
  validates :image_file_name,
            format: {
              with: /\w+\.(jpg|png)\z/i,
              message: 'must be a JPG or PNG image',
            }
  validates :rating, inclusion: { in: RATINGS }

  scope :released,
        -> { where('released_on < ?', Time.now).order(released_on: :desc) }

  scope :upcoming,
        -> { where('released_on > ?', Time.now).order(released_on: :desc) }

  scope :recent, ->(max = 5) { released.limit(max) }

  def flop?
    total_gross < 25_000_000 && reviews.size < 50
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = title.parameterize
  end
end
