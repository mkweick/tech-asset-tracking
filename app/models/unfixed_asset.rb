class UnfixedAsset < ActiveRecord::Base
  belongs_to :category
  has_one :unfixed_assignment, dependent: :restrict_with_error
  has_one :user, through: :unfixed_assignment
end