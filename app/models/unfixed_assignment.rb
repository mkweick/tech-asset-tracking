class UnfixedAssignment < ActiveRecord::Base
  
  belongs_to :unfixed_asset
  belongs_to :user
  
end