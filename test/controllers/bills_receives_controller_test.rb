require 'test_helper'

class BillsReceivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bills_receife = bills_receives(:one)
  end

  test "should get index" do
    get bills_receives_url
    assert_response :success
  end

  test "should get new" do
    get new_bills_receife_url
    assert_response :success
  end

  test "should create bills_receife" do
    assert_difference('BillsReceife.count') do
      post bills_receives_url, params: { bills_receife: { amount: @bills_receife.amount, attachment: @bills_receife.attachment, billing_agency: @bills_receife.billing_agency, category_id: @bills_receife.category_id, competence: @bills_receife.competence, deadline: @bills_receife.deadline, description: @bills_receife.description, due_date: @bills_receife.due_date, expiration_day: @bills_receife.expiration_day, form_payment: @bills_receife.form_payment, n_doc: @bills_receife.n_doc, ocorrence: @bills_receife.ocorrence, people_associated_id: @bills_receife.people_associated_id, work_days_onluy: @bills_receife.work_days_onluy } }
    end

    assert_redirected_to bills_receife_url(BillsReceife.last)
  end

  test "should show bills_receife" do
    get bills_receife_url(@bills_receife)
    assert_response :success
  end

  test "should get edit" do
    get edit_bills_receife_url(@bills_receife)
    assert_response :success
  end

  test "should update bills_receife" do
    patch bills_receife_url(@bills_receife), params: { bills_receife: { amount: @bills_receife.amount, attachment: @bills_receife.attachment, billing_agency: @bills_receife.billing_agency, category_id: @bills_receife.category_id, competence: @bills_receife.competence, deadline: @bills_receife.deadline, description: @bills_receife.description, due_date: @bills_receife.due_date, expiration_day: @bills_receife.expiration_day, form_payment: @bills_receife.form_payment, n_doc: @bills_receife.n_doc, ocorrence: @bills_receife.ocorrence, people_associated_id: @bills_receife.people_associated_id, work_days_onluy: @bills_receife.work_days_onluy } }
    assert_redirected_to bills_receife_url(@bills_receife)
  end

  test "should destroy bills_receife" do
    assert_difference('BillsReceife.count', -1) do
      delete bills_receife_url(@bills_receife)
    end

    assert_redirected_to bills_receives_url
  end
end
