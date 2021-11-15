class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :genre_joins, dependent: :destroy
  has_many :movies, through: :genre_joins
end
