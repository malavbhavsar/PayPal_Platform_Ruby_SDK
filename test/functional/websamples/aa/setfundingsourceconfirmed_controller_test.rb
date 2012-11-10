require 'test_helper'

class Websamples::Aa::SetfundingsourceconfirmedControllerTest < ActionController::TestCase
  test "should get begin" do
    get :begin
    assert_response :success
  end

  test "should get set" do
    get :set
    assert_response :success
  end

  test "should get funding_source_details" do
    get :funding_source_details
    assert_response :success
  end

end
