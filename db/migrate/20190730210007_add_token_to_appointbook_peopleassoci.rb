class AddTokenToAppointbookPeopleassoci < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointbook_peopleassocis, :token, :string
  end
end
