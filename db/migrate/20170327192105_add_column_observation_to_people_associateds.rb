class AddColumnObservationToPeopleAssociateds < ActiveRecord::Migration[5.0]
  def change
  	add_column :people_associateds, :observation, :text
  end
end
