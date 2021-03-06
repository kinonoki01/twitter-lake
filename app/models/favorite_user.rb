class FavoriteUser < ApplicationRecord
  validates :twitter_account, presence: true, length: { maximum: 100 }
  validates :position, presence: { scope: :user_id}
  
  belongs_to :user
end
