class UnfixedAsset < ActiveRecord::Base
  
  belongs_to :category
  has_one :unfixed_assignment
  has_one :user, through: :unfixed_assignment
  
end