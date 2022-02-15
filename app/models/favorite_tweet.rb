class FavoriteTweet < ApplicationRecord
  validates :tweet, presence: true, length: { maximum: 3000 }
  validates :position, presence: { scope: :folder_id }
  
  belongs_to :folder
end
