require 'test_helper'

class Websamples::Aa::AddbankaccountControllerTest < ActionController::TestCase
  test "should get begin" do
    get :begin
    assert_response :success
  end

  test "should get add_bank" do
    get :add_bank
    assert_response :success
  end

  test "should get add_bank_account_details" do
    get :add_bank_account_details
    assert_response :success
  end

end
