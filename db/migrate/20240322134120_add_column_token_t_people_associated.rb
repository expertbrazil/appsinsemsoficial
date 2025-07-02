class AddColumnTokenTPeopleAssociated < ActiveRecord::Migration[5.0]
  def change
  	add_column :people_associateds, :token, :string 
  end
end
