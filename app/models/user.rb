class User < ActiveRecord::Base
	validates :username, :password, presence: true
	validates :username, uniqueness: true

	has_secure_password

    def self.authenticate(username, password)
      user = find_by(username: username)
      user && user.authenticate(password)
    end
end
