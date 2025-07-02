class AddColumnCellPhone1And2ToPeopleAssociateds < ActiveRecord::Migration[5.0]
  def change
  	add_column :people_associateds, :cell_phone1, :string
  	add_column :people_associateds, :cell_phone2, :string
  	add_column :people_associateds, :hollering_registration, :string
  	add_column :people_associateds, :affiliate_date, :date
  end
end
