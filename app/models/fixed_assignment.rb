class FixedAssignment < ActiveRecord::Base
  
  belongs_to :fixed_asset
  belongs_to :user
  
end