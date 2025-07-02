class AddColumnTermOfConsentToPeopleAssociateds < ActiveRecord::Migration[5.0]
  def change
  	add_column :people_associateds, :term_of_consent, :boolean, default: false
  end
end
