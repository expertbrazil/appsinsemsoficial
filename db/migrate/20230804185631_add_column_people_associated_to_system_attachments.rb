class AddColumnPeopleAssociatedToSystemAttachments < ActiveRecord::Migration[5.0]
  def change
  	add_column :system_attachments, :people_associated_id, :integer, foreign_key: true
  end
end
