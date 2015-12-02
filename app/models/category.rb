class Category < ActiveRecord::Base
  has_many :fixed_assets
  has_many :unfixed_assets
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  def to_param
    self.name.gsub(' ', '-').downcase
  end
  
  def name=(s)
    write_attribute :name, s.to_s.split.map(&:capitalize).join(' ')
  end
end