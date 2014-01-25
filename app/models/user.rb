require 'bcrypt'

class User < ActiveRecord::Base
  def initialize(attributes)
    @salt = BCrypt::Engine.generate_salt(10)
    @encrypted_password = hash_it(attributes[:password])
  end

  def authenticate(entered_password)
    @encrypted_password == hash_it(entered_password)
  end

  private

  def hash_it(raw_password)
    BCrypt::Engine.hash_secret(raw_password, @salt)
  end
end
