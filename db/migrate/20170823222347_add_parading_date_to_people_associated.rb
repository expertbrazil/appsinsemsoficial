class AddParadingDateToPeopleAssociated < ActiveRecord::Migration[5.0]
  def change
    add_column :people_associateds, :parading_date, :date
  end
end
