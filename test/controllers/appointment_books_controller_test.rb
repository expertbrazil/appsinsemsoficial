require 'test_helper'

class AppointmentBooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appointment_book = appointment_books(:one)
  end

  test "should get index" do
    get appointment_books_url
    assert_response :success
  end

  test "should get new" do
    get new_appointment_book_url
    assert_response :success
  end

  test "should create appointment_book" do
    assert_difference('AppointmentBook.count') do
      post appointment_books_url, params: { appointment_book: { professional_id: @appointment_book.professional_id } }
    end

    assert_redirected_to appointment_book_url(AppointmentBook.last)
  end

  test "should show appointment_book" do
    get appointment_book_url(@appointment_book)
    assert_response :success
  end

  test "should get edit" do
    get edit_appointment_book_url(@appointment_book)
    assert_response :success
  end

  test "should update appointment_book" do
    patch appointment_book_url(@appointment_book), params: { appointment_book: { professional_id: @appointment_book.professional_id } }
    assert_redirected_to appointment_book_url(@appointment_book)
  end

  test "should destroy appointment_book" do
    assert_difference('AppointmentBook.count', -1) do
      delete appointment_book_url(@appointment_book)
    end

    assert_redirected_to appointment_books_url
  end
end
