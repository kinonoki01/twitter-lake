class FavoriteUser < ApplicationRecord
  validates :twitter_account, length: { maximum: 100 }
  validates :position, presence: true
  
  belongs_to :user
end
