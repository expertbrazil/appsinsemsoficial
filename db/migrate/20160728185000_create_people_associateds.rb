class CreatePeopleAssociateds < ActiveRecord::Migration[5.0]
  def change
    create_table :people_associateds do |t|
      t.integer :number_registration
      t.string :name
      t.date :birthdate
      t.string :gender
      t.string :email
      t.string :phone
      t.string :address
      t.integer :number
      t.string :complement
      t.string :zipcode
      t.string :burgh
      t.string :city
      t.string :state
      t.string :cpf
      t.string :rg
      t.string :marital_status
      t.string :place_birth
      t.integer :scholarity
      t.string :profession
      t.string :photo
      t.integer :situation
      t.string :mother
      t.string :father
      t.string :breed
      t.string :title_voter
      t.string :zone_voter
      t.string :section_voter
      t.string :workplace
      t.date :admission_date
      t.integer :bond

      t.timestamps
    end
  end
end
