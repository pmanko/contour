require 'test_helper'

class Contour::SessionsControllerTest < ActionController::TestCase

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "return user json object on login" do
    post :create, user: { email: users(:valid).email, password: 'password' }, format: 'json'

    object = JSON.parse(@response.body)
    assert_equal true, object['success']
    assert_equal users(:valid).id, object['user']['id']
    assert_equal 'FirstName', object['user']['first_name']
    assert_equal 'LastName', object['user']['last_name']
    assert_equal 'valid@example.com', object['user']['email']
    assert object['user'].keys.include?('authentication_token')


    assert_response :success
  end

  test "should do a graceful redirect to ldap with primary email" do
    post :create, user: { email: users(:valid).email, password: '' }

    assert_redirected_to '/auth/ldap'
  end

  test "should do a graceful redirect to google_apps through secondary email" do
    post :create, user: { email: 'test@gmail.com', password: '' }

    assert_redirected_to '/auth/google_apps'
  end

  test "should not login invalid credentials" do
    post :create, user: { email: '', password: '' }

    assert_response :success
  end

end