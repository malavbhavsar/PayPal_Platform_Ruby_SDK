require 'test_helper'

class Websamples::Ap::PaymentdetailsControllerTest < ActionController::TestCase
  test "should get begin" do
    get :begin
    assert_response :success
  end

  test "should get getPaymentDetails" do
    get :getPaymentDetails
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
