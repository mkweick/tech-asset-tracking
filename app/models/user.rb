class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PAGE_OFFSET = 25
  
  has_many :fixed_assignments
  has_many :fixed_assets, through: :fixed_assignments
  has_many :unfixed_assignments
  has_many :unfixed_assets, through: :unfixed_assignments
  
  validates :username,  presence: true, uniqueness: { case_sensitive: false },
                        length: { minimum: 4,
                                  message: "is too short (minimum is 4)" },
                        format: { with: /\A[a-zA-Z0-9_-]+\Z/,
                                  message: "can only contain alphanumeric 
                                            characters and hypens/underscores" }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false },
                              format: { with: VALID_EMAIL_REGEX,
                                        message: "is not a valid email format" }
  has_secure_password
  validates :password, on: :create, length: { minimum: 6,
                                      message: "is too short (minimum is 6)" }
  
  def to_param
    self.username.downcase
  end
  
  def first_name=(s)
    write_attribute :first_name, s.to_s.capitalize
  end
  
  def last_name=(s)
    write_attribute :last_name, s.to_s.capitalize
  end
end