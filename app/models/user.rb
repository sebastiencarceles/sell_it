class User < ApplicationRecord
  has_secure_password
  
  has_many :classifieds

  validates_presence_of :fullname, :username, :password_digest
  validates_uniqueness_of :username

  def self.from_token_request(request)
    username = request.params['auth'] && request.params['auth']['username']
    self.find_by(username: username)
  end
end
