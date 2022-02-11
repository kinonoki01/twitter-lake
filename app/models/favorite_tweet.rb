class FavoriteTweet < ApplicationRecord
  validates :tweet, presence: true, length: { maximum: 3000 }
  validates :position, presence: true
  
  belongs_to :folder
end
