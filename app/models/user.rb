class User < ActiveRecord::Base
  validates :username,  presence: true, 
                        uniqueness: { case_sensitive: false },
                        length: { minimum: 4 }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  def to_param
    self.username
  end
end