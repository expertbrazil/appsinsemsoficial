class CreateProfessionals < ActiveRecord::Migration[5.0]
  def change
    create_table :professionals do |t|
      t.string :name
      t.string :cpf
      t.string :rg
      t.string :advice
      t.integer :type_function

      t.timestamps
    end
  end
end
