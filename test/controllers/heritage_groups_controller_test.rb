require 'test_helper'

class HeritageGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @heritage_group = heritage_groups(:one)
  end

  test "should get index" do
    get heritage_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_heritage_group_url
    assert_response :success
  end

  test "should create heritage_group" do
    assert_difference('HeritageGroup.count') do
      post heritage_groups_url, params: { heritage_group: { name: @heritage_group.name } }
    end

    assert_redirected_to heritage_group_url(HeritageGroup.last)
  end

  test "should show heritage_group" do
    get heritage_group_url(@heritage_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_heritage_group_url(@heritage_group)
    assert_response :success
  end

  test "should update heritage_group" do
    patch heritage_group_url(@heritage_group), params: { heritage_group: { name: @heritage_group.name } }
    assert_redirected_to heritage_group_url(@heritage_group)
  end

  test "should destroy heritage_group" do
    assert_difference('HeritageGroup.count', -1) do
      delete heritage_group_url(@heritage_group)
    end

    assert_redirected_to heritage_groups_url
  end
end
