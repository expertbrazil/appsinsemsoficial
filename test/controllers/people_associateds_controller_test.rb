require 'test_helper'

class PeopleAssociatedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @people_associated = people_associateds(:one)
  end

  test "should get index" do
    get people_associateds_url
    assert_response :success
  end

  test "should get new" do
    get new_people_associated_url
    assert_response :success
  end

  test "should create people_associated" do
    assert_difference('PeopleAssociated.count') do
      post people_associateds_url, params: { people_associated: { address: @people_associated.address, admission_date: @people_associated.admission_date, birthdate: @people_associated.birthdate, bond: @people_associated.bond, breed: @people_associated.breed, burgh: @people_associated.burgh, city: @people_associated.city, complement: @people_associated.complement, cpf: @people_associated.cpf, email: @people_associated.email, father: @people_associated.father, gender: @people_associated.gender, marital_status: @people_associated.marital_status, mother: @people_associated.mother, name: @people_associated.name, number: @people_associated.number, number_registration: @people_associated.number_registration, phone: @people_associated.phone, photo: @people_associated.photo, place_birth: @people_associated.place_birth, profession: @people_associated.profession, rg: @people_associated.rg, scholarity: @people_associated.scholarity, section_voter: @people_associated.section_voter, situation: @people_associated.situation, state: @people_associated.state, title_voter: @people_associated.title_voter, workplace: @people_associated.workplace, zipcode: @people_associated.zipcode, zone_voter: @people_associated.zone_voter } }
    end

    assert_redirected_to people_associated_url(PeopleAssociated.last)
  end

  test "should show people_associated" do
    get people_associated_url(@people_associated)
    assert_response :success
  end

  test "should get edit" do
    get edit_people_associated_url(@people_associated)
    assert_response :success
  end

  test "should update people_associated" do
    patch people_associated_url(@people_associated), params: { people_associated: { address: @people_associated.address, admission_date: @people_associated.admission_date, birthdate: @people_associated.birthdate, bond: @people_associated.bond, breed: @people_associated.breed, burgh: @people_associated.burgh, city: @people_associated.city, complement: @people_associated.complement, cpf: @people_associated.cpf, email: @people_associated.email, father: @people_associated.father, gender: @people_associated.gender, marital_status: @people_associated.marital_status, mother: @people_associated.mother, name: @people_associated.name, number: @people_associated.number, number_registration: @people_associated.number_registration, phone: @people_associated.phone, photo: @people_associated.photo, place_birth: @people_associated.place_birth, profession: @people_associated.profession, rg: @people_associated.rg, scholarity: @people_associated.scholarity, section_voter: @people_associated.section_voter, situation: @people_associated.situation, state: @people_associated.state, title_voter: @people_associated.title_voter, workplace: @people_associated.workplace, zipcode: @people_associated.zipcode, zone_voter: @people_associated.zone_voter } }
    assert_redirected_to people_associated_url(@people_associated)
  end

  test "should destroy people_associated" do
    assert_difference('PeopleAssociated.count', -1) do
      delete people_associated_url(@people_associated)
    end

    assert_redirected_to people_associateds_url
  end
end
