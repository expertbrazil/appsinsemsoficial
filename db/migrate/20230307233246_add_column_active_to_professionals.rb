class AddColumnActiveToProfessionals < ActiveRecord::Migration[5.0]
  def change
  	add_column :professionals, :active, :boolean, default: true
  end
end
