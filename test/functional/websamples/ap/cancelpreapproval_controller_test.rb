require 'test_helper'

class Websamples::Ap::CancelpreapprovalControllerTest < ActionController::TestCase
  test "should get cancelPreapproval" do
    get :cancelPreapproval
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
