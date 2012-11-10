require 'test_helper'

class Websamples::Aa::AddpaymentcardControllerTest < ActionController::TestCase
  test "should get begin" do
    get :begin
    assert_response :success
  end

  test "should get add_card" do
    get :add_card
    assert_response :success
  end

  test "should get add_payment_card_details" do
    get :add_payment_card_details
    assert_response :success
  end

end
