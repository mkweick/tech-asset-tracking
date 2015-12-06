class UnfixedAsset < ActiveRecord::Base
  PAGE_OFFSET = 25
  
  belongs_to :category
  has_one :unfixed_assignment, dependent: :restrict_with_error
  has_one :user, through: :unfixed_assignment
  
  validates :mfg_name, presence: true
  validates :model_num, presence: true
  validates :serial_num, presence: true, uniqueness: { case_sensitive: false },
                         format: { with: /\A[\da-zA-Z_-]+\z/,
                                   message: "can only contain alphanumeric 
                                             characters and hypens/underscores"}
  validates :description, presence: true, length: { maximum: 100 }
  validates :category_id, presence: true
  validates :purchase_date, presence: true
  
  def to_param
    self.serial_num
  end
end