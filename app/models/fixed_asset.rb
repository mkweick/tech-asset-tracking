class FixedAsset < ActiveRecord::Base
  
  belongs_to :category
  has_one :fixed_assignment
  has_one :user, through: :fixed_assignment
  
end