require 'test_helper'

class Websamples::Ap::ExecutepayControllerTest < ActionController::TestCase
  test "should get execute" do
    get :execute
    assert_response :success
  end

  test "should get thanks" do
    get :thanks
    assert_response :success
  end

end
