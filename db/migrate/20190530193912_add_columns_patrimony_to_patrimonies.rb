class AddColumnsPatrimonyToPatrimonies < ActiveRecord::Migration[5.0]
  def change
  	add_column :patrimonies, :current_amount, :decimal, precision: 10, scale: 2, default: 0  
  	add_column :patrimonies, :date_of_incorporation, :date
  	add_column :patrimonies, :request_of, :string
  	add_column :patrimonies, :entry_note, :string
  	add_column :patrimonies, :type_incorporation_describe, :string
  	add_column :patrimonies, :effort_describe, :string
  	add_column :patrimonies, :inactive_describe, :string
  	

  	add_reference :patrimonies, :supplier, foreign_key: true
  	add_reference :patrimonies, :room, foreign_key: true
  	add_reference :patrimonies, :heritage_group, foreign_key: true
  	add_reference :patrimonies, :type_incorporation, foreign_key: true
  	add_reference :patrimonies, :effort, foreign_key: true
  end
end
