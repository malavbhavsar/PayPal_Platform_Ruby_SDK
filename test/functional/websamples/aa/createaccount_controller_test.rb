require 'test_helper'

class Websamples::Aa::CreateaccountControllerTest < ActionController::TestCase
  test "should get begin" do
    get :begin
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get account_details" do
    get :account_details
    assert_response :success
  end

end
