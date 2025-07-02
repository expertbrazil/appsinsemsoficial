require 'test_helper'

class EffortsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @effort = efforts(:one)
  end

  test "should get index" do
    get efforts_url
    assert_response :success
  end

  test "should get new" do
    get new_effort_url
    assert_response :success
  end

  test "should create effort" do
    assert_difference('Effort.count') do
      post efforts_url, params: { effort: { name: @effort.name, to_describe: @effort.to_describe } }
    end

    assert_redirected_to effort_url(Effort.last)
  end

  test "should show effort" do
    get effort_url(@effort)
    assert_response :success
  end

  test "should get edit" do
    get edit_effort_url(@effort)
    assert_response :success
  end

  test "should update effort" do
    patch effort_url(@effort), params: { effort: { name: @effort.name, to_describe: @effort.to_describe } }
    assert_redirected_to effort_url(@effort)
  end

  test "should destroy effort" do
    assert_difference('Effort.count', -1) do
      delete effort_url(@effort)
    end

    assert_redirected_to efforts_url
  end
end
