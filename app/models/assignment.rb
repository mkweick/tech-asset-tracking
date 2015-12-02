class Assignment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :assetable, polymorphic: true
  belongs_to :fixed_asset, foreign_key: 'assetable'
  
end