require 'test_helper'

class Websamples::Ap::RefundControllerTest < ActionController::TestCase
  test "should get refund" do
    get :refund
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
