require 'test_helper'

class FinancialAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @financial_account = financial_accounts(:one)
  end

  test "should get index" do
    get financial_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_financial_account_url
    assert_response :success
  end

  test "should create financial_account" do
    assert_difference('FinancialAccount.count') do
      post financial_accounts_url, params: { financial_account: { name: @financial_account.name, status: @financial_account.status } }
    end

    assert_redirected_to financial_account_url(FinancialAccount.last)
  end

  test "should show financial_account" do
    get financial_account_url(@financial_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_financial_account_url(@financial_account)
    assert_response :success
  end

  test "should update financial_account" do
    patch financial_account_url(@financial_account), params: { financial_account: { name: @financial_account.name, status: @financial_account.status } }
    assert_redirected_to financial_account_url(@financial_account)
  end

  test "should destroy financial_account" do
    assert_difference('FinancialAccount.count', -1) do
      delete financial_account_url(@financial_account)
    end

    assert_redirected_to financial_accounts_url
  end
end
