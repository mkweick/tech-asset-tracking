class Category < ActiveRecord::Base
  has_many :fixed_assets, dependent: :restrict_with_error
  has_many :unfixed_assets, dependent: :restrict_with_error
  
  validates :name, presence: true, uniqueness: { case_sensitive: false },
                   length: { maximum: 20, message: "is to long (max is 20)" },
                   format: { with: /\A[a-zA-Z\s]+\Z/,
                             message: "can only contain letters and spaces" }
  
  def to_param
    self.name.gsub(' ', '-').downcase
  end
  
  def name=(s)
    write_attribute :name, s.to_s.split.map(&:capitalize).join(' ')
  end
end