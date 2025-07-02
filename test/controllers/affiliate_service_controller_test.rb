require 'test_helper'

class AffiliateServiceControllerTest < ActionDispatch::IntegrationTest
  test "should get appointment_book" do
    get affiliate_service_appointment_book_url
    assert_response :success
  end

end
