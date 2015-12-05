class FixedAssignment < ActiveRecord::Base
  belongs_to :fixed_asset
  belongs_to :user
  
  validates_uniqueness_of :fixed_asset_id, message: "assigned to another user"
end