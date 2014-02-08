require "spec_helper"

describe User do
  describe "#authenticate" do
    let(:user) { User.new(password: 'password') }

    context "when the entered password is correct" do
      it "authenticates legit passwords" do
        user.authenticate('password').should be_true
      end
    end

    context "when the entered password is incorrect" do
      it "does not authenticate" do
        user.authenticate('wrong').should be_false
      end
    end

    it "works like this" do
      salt = BCrypt::Engine.generate_salt(10)
      first = BCrypt::Engine.hash_secret("blah", salt)
      second = BCrypt::Engine.hash_secret("blah", salt)
      first.should == second
    end
  end

  describe "#save" do
    it "loads fine from the database" do
      user = User.new(password: 'blah')
      user.save!

      reloaded_user = User.find(user.id)
      reloaded_user.authenticate('blah').should be_true
      reloaded_user.encrypted_password.should_not be_nil
      reloaded_user.salt.should_not be_nil
    end
  end
end
