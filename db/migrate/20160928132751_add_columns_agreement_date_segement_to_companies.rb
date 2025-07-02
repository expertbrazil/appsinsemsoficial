class AddColumnsAgreementDateSegementToCompanies < ActiveRecord::Migration[5.0]
  def change
  	add_reference :companies, :segment, index: true
  	add_column :companies, :agreement_at, :date
  end
end
