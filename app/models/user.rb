require 'bcrypt'

class User < ActiveRecord::Base
  def initialize(attributes)
    if attributes.key?(:password)
      salt = BCrypt::Engine.generate_salt(10)
      encrypted_password = hash_it(attributes[:password], salt)
      super({salt: salt, encrypted_password: encrypted_password})
    else
      super
    end
  end

  def authenticate(entered_password)
    self.encrypted_password == hash_it(entered_password, self.salt)
  end

  private

  def hash_it(raw_password, salt)
    BCrypt::Engine.hash_secret(raw_password, salt)
  end
end
