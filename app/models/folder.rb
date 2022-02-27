class Folder < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :position, presence: true, uniqueness: { scope: :user_id }
  
  belongs_to :user
  has_many :favorite_tweets, dependent: :destroy
end
