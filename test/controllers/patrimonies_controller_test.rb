require 'test_helper'

class PatrimoniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @patrimony = patrimonies(:one)
  end

  test "should get index" do
    get patrimonies_url
    assert_response :success
  end

  test "should get new" do
    get new_patrimony_url
    assert_response :success
  end

  test "should create patrimony" do
    assert_difference('Patrimony.count') do
      post patrimonies_url, params: { patrimony: { amount: @patrimony.amount, date_of_acquisition: @patrimony.date_of_acquisition, department_id: @patrimony.department_id, description: @patrimony.description, name: @patrimony.name, patrimony_number: @patrimony.patrimony_number, quantity: @patrimony.quantity } }
    end

    assert_redirected_to patrimony_url(Patrimony.last)
  end

  test "should show patrimony" do
    get patrimony_url(@patrimony)
    assert_response :success
  end

  test "should get edit" do
    get edit_patrimony_url(@patrimony)
    assert_response :success
  end

  test "should update patrimony" do
    patch patrimony_url(@patrimony), params: { patrimony: { amount: @patrimony.amount, date_of_acquisition: @patrimony.date_of_acquisition, department_id: @patrimony.department_id, description: @patrimony.description, name: @patrimony.name, patrimony_number: @patrimony.patrimony_number, quantity: @patrimony.quantity } }
    assert_redirected_to patrimony_url(@patrimony)
  end

  test "should destroy patrimony" do
    assert_difference('Patrimony.count', -1) do
      delete patrimony_url(@patrimony)
    end

    assert_redirected_to patrimonies_url
  end
end
