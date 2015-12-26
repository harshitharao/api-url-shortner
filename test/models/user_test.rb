require 'test_helper'

class UserTest < ActiveSupport::TestCase
     test "should check whether email, name and password empty fields will throw error" do
       user = User.new()
       assert user.invalid?
       assert user.errors[:email].any?
       assert user.errors[:name].any?
       assert user.errors[:password].any?
     end

     test "should check whether user with invalid email will throw error" do
       user = User.new(email: "invalidemail")
       assert user.invalid?
       assert_equal ["is invalid"],user.errors[:email]
     end

     test "should check whether duplicate email will throw error" do
       User.destroy_all
       user1 = User.create(email: "validemail@gmail.com", name: "Valid user", password: "hello123")
       assert user1.valid?
       user2 = User.create(email: "validemail@gmail.com", name: "Valid user 2", password: "blah123")
       assert_equal ["has already been taken"], user2.errors[:email]
     end

     test "should check minimum length of password to be 6" do
       user = User.create(email: "validemail@gmail.com", name: "Valid user", password: "inva")
       assert_equal ["is too short (minimum is 6 characters)"],user.errors[:password]
     end

     test "should create a valid user in db and assign api token and password digest" do
       User.destroy_all
       user = User.create!(email: "validemail@gmail.com", name: "Valid user", password: "validpassword")
       assert user.valid?
       assert_equal false, user.api_token.nil?
       assert_equal false, user.password_digest.nil?
     end
end
