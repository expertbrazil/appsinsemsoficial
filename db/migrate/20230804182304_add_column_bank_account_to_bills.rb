class AddColumnBankAccountToBills < ActiveRecord::Migration[5.0]
  def change

  	add_reference :bills_pays, :bank_account
  	add_reference :bills_receives, :bank_account
  end
end
