require 'test_helper'

class Websamples::Ap::SetpreapprovalControllerTest < ActionController::TestCase
  test "should get preapproval" do
    get :preapproval
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
