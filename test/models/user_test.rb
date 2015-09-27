require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.take
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should not be valid due to email" do
    user = User.new(name: "Dmitry Petrov", email: "wrongemail.ru",
      password: "barfoo", password_confirmation: "barfoo")
    assert user.invalid?
  end

  test "email is unique" do
    user = User.new(name: "Victor Petrovich", email: @user.email,
      password: "raboof", password_confirmation: "raboof")
    assert user.invalid?
  end

  test "password should be present" do
    user = User.new(name: "Name", email: "e@mail.ru")
    assert user.invalid?
  end

  test "password should not be blank" do
    user = User.new(name: "Name", email: "e@mail.ru", password: "", password_confirmation: "")
    assert user.invalid?
  end
end
