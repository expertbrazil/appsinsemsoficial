require 'test_helper'

class ComteleControllerTest < ActionDispatch::IntegrationTest
  test "should get sms" do
    get comtele_sms_url
    assert_response :success
  end

end
