class AddColumnBillsPayIdToBillsReceive < ActiveRecord::Migration[5.0]
  def change
  	add_reference :bills_receives, :bills_pay, index: true
  end
end
