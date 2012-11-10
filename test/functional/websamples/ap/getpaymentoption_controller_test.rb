require 'test_helper'

class Websamples::Ap::GetpaymentoptionControllerTest < ActionController::TestCase
  test "should get paymentOption" do
    get :paymentOption
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
