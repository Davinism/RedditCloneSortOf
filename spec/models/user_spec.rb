require 'rails_helper'
require 'spec_helper'

describe User do
  subject(:user) { FactoryGirl.build(:user, username: "davinkim", password: "password") }

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_length_of(:password).is_at_least(6).on(:create)}

  it { should have_many(:subs) }
  # it { should have_many(:user_votes) }
  # it { should have_many(:comments) }


  describe "#is_password?" do
    it "returns true if the correct password has been given" do
      expect(user.is_password?("password")).to be true
    end

    it "returns false if an incorrect password has been given" do
      expect(user.is_password?("passwords")).to be false
    end
  end

  describe "#reset_session_token!" do
    it "returns a session token that is different than the original" do
      old_session_token = user.session_token
      expect(user.reset_session_token! == old_session_token).to be false
    end
  end

  describe "::find_by_credentials" do
    it "returns the user if the correct username and password pair are given" do
      expect(User.find_by_credentials("davinkim", "password")).to eq(user)
    end

    it "returns nil if the incorrect username and password pair are given" do
      expect(User.find_by_credentials("marvinkim", "password")).to be_nil
    end
  end

end
