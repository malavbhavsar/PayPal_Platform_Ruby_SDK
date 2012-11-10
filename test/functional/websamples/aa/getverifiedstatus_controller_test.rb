require 'test_helper'

class Websamples::Aa::GetverifiedstatusControllerTest < ActionController::TestCase
  test "should get begin" do
    get :begin
    assert_response :success
  end

  test "should get getStatus" do
    get :getStatus
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
