class AddColumnValidityCardPartnerToPeopleAssociateds < ActiveRecord::Migration[5.0]
  def change
  	add_column :people_associateds, :validity_card, :datetime
  	add_column :people_associateds, :partner, :boolean, default: false
  end
end
