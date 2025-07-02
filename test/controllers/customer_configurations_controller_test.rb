require 'test_helper'

class CustomerConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_configuration = customer_configurations(:one)
  end

  test "should get index" do
    get customer_configurations_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_configuration_url
    assert_response :success
  end

  test "should create customer_configuration" do
    assert_difference('CustomerConfiguration.count') do
      post customer_configurations_url, params: { customer_configuration: { address: @customer_configuration.address, cell_phone: @customer_configuration.cell_phone, city: @customer_configuration.city, cnpj: @customer_configuration.cnpj, date_fundation: @customer_configuration.date_fundation, ficha: @customer_configuration.ficha, logo: @customer_configuration.logo, name: @customer_configuration.name, phone: @customer_configuration.phone, president: @customer_configuration.president, state: @customer_configuration.state, string: @customer_configuration.string } }
    end

    assert_redirected_to customer_configuration_url(CustomerConfiguration.last)
  end

  test "should show customer_configuration" do
    get customer_configuration_url(@customer_configuration)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_configuration_url(@customer_configuration)
    assert_response :success
  end

  test "should update customer_configuration" do
    patch customer_configuration_url(@customer_configuration), params: { customer_configuration: { address: @customer_configuration.address, cell_phone: @customer_configuration.cell_phone, city: @customer_configuration.city, cnpj: @customer_configuration.cnpj, date_fundation: @customer_configuration.date_fundation, ficha: @customer_configuration.ficha, logo: @customer_configuration.logo, name: @customer_configuration.name, phone: @customer_configuration.phone, president: @customer_configuration.president, state: @customer_configuration.state, string: @customer_configuration.string } }
    assert_redirected_to customer_configuration_url(@customer_configuration)
  end

  test "should destroy customer_configuration" do
    assert_difference('CustomerConfiguration.count', -1) do
      delete customer_configuration_url(@customer_configuration)
    end

    assert_redirected_to customer_configurations_url
  end
end
