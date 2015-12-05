class UnfixedAssignment < ActiveRecord::Base
  belongs_to :unfixed_asset
  belongs_to :user
  
  validates_uniqueness_of :unfixed_asset_id, message: "assigned to another user"
end