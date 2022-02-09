class Folder < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :position, presence: true, uniqueness: true
  
  belongs_to :user
end
