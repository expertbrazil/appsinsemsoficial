class CreateSystemAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :system_attachments do |t|
	    t.integer :dependent_id, foreign_key: true
      t.integer :bills_pay_id, foreign_key: true
      t.integer :bills_receife_id, foreign_key: true
      t.string :name
      t.string :archive

      t.timestamps
    end
  end
end