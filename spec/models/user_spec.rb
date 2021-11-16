require 'rails_helper'

RSpec.describe User, type: :model do
  # Factory context
  context "factory" do
    # before all the test we build the user instance for our test
    before(:all) do
      @user = build(:user)
    end
    # we can check to see if the @user is valid
    it "has a valid user" do
      expect(@user).to be_valid
    end
    # we can check to see if the @user or the user has the right username
    it "has the the correct username" do
      expect(@user.username).to eq ("Saman")
    end
    # we check to see if the user has the right password
    it "should has the right password" do
      expect(@user.password).to eq 'password1'
    end
  end
  # End of factory context

  # validation context
  context "validation" do 
    before(:each) do
      @user = build(:user)
    end

    it "is invlaid without the username" do
      # here we change the existing username to nil to check the validation
      @user.username = nil
      expect(@user).to_not be_valid
    end

    it "is invalid without an email" do
      user = build(:user, {email: nil})
      expect(user).to_not be_valid
    end

    it "is invalid without password" do 
      user = build(:user, {password: nil})
      expect(user).to_not be_valid
    end

    it "is invalid without password" do 
      user = build(:user, {password_confirmation: nil})
      expect(user).to_not be_valid
    end

    it "is invalid when password and confirmation don't match" do
      user = build(:user, password_confirmation: "password2")
      expect(user).to_not be_valid
    end
  end
  # end of validation context
end
