class UserSetting < ApplicationRecord
  validates :twitter_account_name, length: { maximum: 50 }
  
  belongs_to :user
end
