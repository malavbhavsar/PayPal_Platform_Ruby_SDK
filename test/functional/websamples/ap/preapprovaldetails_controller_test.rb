require 'test_helper'

class Websamples::Ap::PreapprovaldetailsControllerTest < ActionController::TestCase
  test "should get getPreapprovalDetails" do
    get :getPreapprovalDetails
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
