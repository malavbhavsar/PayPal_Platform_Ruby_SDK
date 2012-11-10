require 'test_helper'

class Websamples::Ap::ConvertcurrencyControllerTest < ActionController::TestCase
  test "should get setConvertCurrency" do
    get :setConvertCurrency
    assert_response :success
  end

  test "should get details" do
    get :details
    assert_response :success
  end

end
