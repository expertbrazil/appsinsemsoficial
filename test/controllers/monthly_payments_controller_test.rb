require 'test_helper'

class MonthlyPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monthly_payment = monthly_payments(:one)
  end

  test "should get index" do
    get monthly_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_monthly_payment_url
    assert_response :success
  end

  test "should create monthly_payment" do
    assert_difference('MonthlyPayment.count') do
      post monthly_payments_url, params: { monthly_payment: { amount: @monthly_payment.amount, amount_paid: @monthly_payment.amount_paid, due_date: @monthly_payment.due_date, month: @monthly_payment.month, observation: @monthly_payment.observation, paid: @monthly_payment.paid, pay_day: @monthly_payment.pay_day, people_associated_id: @monthly_payment.people_associated_id } }
    end

    assert_redirected_to monthly_payment_url(MonthlyPayment.last)
  end

  test "should show monthly_payment" do
    get monthly_payment_url(@monthly_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_monthly_payment_url(@monthly_payment)
    assert_response :success
  end

  test "should update monthly_payment" do
    patch monthly_payment_url(@monthly_payment), params: { monthly_payment: { amount: @monthly_payment.amount, amount_paid: @monthly_payment.amount_paid, due_date: @monthly_payment.due_date, month: @monthly_payment.month, observation: @monthly_payment.observation, paid: @monthly_payment.paid, pay_day: @monthly_payment.pay_day, people_associated_id: @monthly_payment.people_associated_id } }
    assert_redirected_to monthly_payment_url(@monthly_payment)
  end

  test "should destroy monthly_payment" do
    assert_difference('MonthlyPayment.count', -1) do
      delete monthly_payment_url(@monthly_payment)
    end

    assert_redirected_to monthly_payments_url
  end
end
