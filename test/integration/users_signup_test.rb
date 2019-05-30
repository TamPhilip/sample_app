require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation ul li", "Name can't be blank"
    assert_select "div#error_explanation ul li", "Email is invalid"
    assert_select "div#error_explanation ul li", "Password is too short (minimum is 6 characters)"
  end

  test "valid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    #if @user.save is false then it will not increase the count by one
    assert_difference 'User.count', 1 do
       post signup_path, params: {
        user: {
          name: "george",
          email: "user@valid.com",
          password: "foobar",
          password_confirmation: "foobar"
        }
      }
    end
    follow_redirect!
    #same test
    assert_select "div.alert","Welcome to the Sample App!"
    assert_not flash.empty?
    
    assert_template 'users/show'
    assert is_logged_in?
  end
end
