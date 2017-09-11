class User < ApplicationRecord
  has_secure_password
  
  has_many :classifieds

  validates_presence_of :fullname, :username, :password_digest
  validates_uniqueness_of :username
end
