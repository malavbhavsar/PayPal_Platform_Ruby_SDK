require 'test_helper'

class Websamples::Ap::SetpayControllerTest < ActionController::TestCase
  test "should get invoke" do
    get :invoke
    assert_response :success
  end

  test "should get pay" do
    get :pay
    assert_response :success
  end

  test "should get pay_details" do
    get :pay_details
    assert_response :success
  end

  test "should get thanks" do
    get :thanks
    assert_response :success
  end

end
