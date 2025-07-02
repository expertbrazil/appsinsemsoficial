class RemoveColumnWorkplaceToPeopleAssociateds < ActiveRecord::Migration[5.0]
  def self.up
  	remove_column :people_associateds, :workplace
  	add_column :people_associateds, :workplace_id, :integer, foreign_key: true
  end  

  def self.down
  	remove_column :people_associateds, :workplace_id
  	add_column :people_associateds, :workplace, :string  	
  end
end
