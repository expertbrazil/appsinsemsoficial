require 'test_helper'

class TypeIncorporationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @type_incorporation = type_incorporations(:one)
  end

  test "should get index" do
    get type_incorporations_url
    assert_response :success
  end

  test "should get new" do
    get new_type_incorporation_url
    assert_response :success
  end

  test "should create type_incorporation" do
    assert_difference('TypeIncorporation.count') do
      post type_incorporations_url, params: { type_incorporation: { name: @type_incorporation.name, to_describe: @type_incorporation.to_describe } }
    end

    assert_redirected_to type_incorporation_url(TypeIncorporation.last)
  end

  test "should show type_incorporation" do
    get type_incorporation_url(@type_incorporation)
    assert_response :success
  end

  test "should get edit" do
    get edit_type_incorporation_url(@type_incorporation)
    assert_response :success
  end

  test "should update type_incorporation" do
    patch type_incorporation_url(@type_incorporation), params: { type_incorporation: { name: @type_incorporation.name, to_describe: @type_incorporation.to_describe } }
    assert_redirected_to type_incorporation_url(@type_incorporation)
  end

  test "should destroy type_incorporation" do
    assert_difference('TypeIncorporation.count', -1) do
      delete type_incorporation_url(@type_incorporation)
    end

    assert_redirected_to type_incorporations_url
  end
end
