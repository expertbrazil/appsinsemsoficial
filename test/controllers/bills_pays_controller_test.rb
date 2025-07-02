require 'test_helper'

class BillsPaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bills_pay = bills_pays(:one)
  end

  test "should get index" do
    get bills_pays_url
    assert_response :success
  end

  test "should get new" do
    get new_bills_pay_url
    assert_response :success
  end

  test "should create bills_pay" do
    assert_difference('BillsPay.count') do
      post bills_pays_url, params: { bills_pay: { amount: @bills_pay.amount, category_id: @bills_pay.category_id, competence_date: @bills_pay.competence_date, deadline: @bills_pay.deadline, description: @bills_pay.description, due_date: @bills_pay.due_date, expiration_day: @bills_pay.expiration_day, n_doc: @bills_pay.n_doc, ocorrence: @bills_pay.ocorrence, payment_form_id: @bills_pay.payment_form_id, payroll_discount: @bills_pay.payroll_discount, people_associated_id: @bills_pay.people_associated_id, receive: @bills_pay.receive, receive_date: @bills_pay.receive_date, state_assm: @bills_pay.state_assm, stop_recurrence: @bills_pay.stop_recurrence, supplier_id: @bills_pay.supplier_id, work_days_only: @bills_pay.work_days_only } }
    end

    assert_redirected_to bills_pay_url(BillsPay.last)
  end

  test "should show bills_pay" do
    get bills_pay_url(@bills_pay)
    assert_response :success
  end

  test "should get edit" do
    get edit_bills_pay_url(@bills_pay)
    assert_response :success
  end

  test "should update bills_pay" do
    patch bills_pay_url(@bills_pay), params: { bills_pay: { amount: @bills_pay.amount, category_id: @bills_pay.category_id, competence_date: @bills_pay.competence_date, deadline: @bills_pay.deadline, description: @bills_pay.description, due_date: @bills_pay.due_date, expiration_day: @bills_pay.expiration_day, n_doc: @bills_pay.n_doc, ocorrence: @bills_pay.ocorrence, payment_form_id: @bills_pay.payment_form_id, payroll_discount: @bills_pay.payroll_discount, people_associated_id: @bills_pay.people_associated_id, receive: @bills_pay.receive, receive_date: @bills_pay.receive_date, state_assm: @bills_pay.state_assm, stop_recurrence: @bills_pay.stop_recurrence, supplier_id: @bills_pay.supplier_id, work_days_only: @bills_pay.work_days_only } }
    assert_redirected_to bills_pay_url(@bills_pay)
  end

  test "should destroy bills_pay" do
    assert_difference('BillsPay.count', -1) do
      delete bills_pay_url(@bills_pay)
    end

    assert_redirected_to bills_pays_url
  end
end
