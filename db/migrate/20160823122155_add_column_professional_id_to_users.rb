class AddColumnProfessionalIdToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :professional_id, :integer, foreign_key: true
  end
end
