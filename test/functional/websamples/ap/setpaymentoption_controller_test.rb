require 'test_helper'

class Websamples::Ap::SetpaymentoptionControllerTest < ActionController::TestCase
  test "should get paymentOption" do
    get :paymentOption
    assert_response :success
  end

  test "should get thanks" do
    get :thanks
    assert_response :success
  end

end
