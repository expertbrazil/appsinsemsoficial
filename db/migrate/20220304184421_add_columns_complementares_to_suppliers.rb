class AddColumnsComplementaresToSuppliers < ActiveRecord::Migration[5.0]
  def change
  		add_column :suppliers, :cpf, :string
  		add_column :suppliers, :cnpj, :string
  		add_column :suppliers, :razao_social, :string
  		add_column :suppliers, :rg, :string
  		add_column :suppliers, :emitter, :string
  		add_column :suppliers, :uf, :string
  		add_column :suppliers, :cell_phone, :string
  		add_column :suppliers, :obs, :text
  		add_column :suppliers, :entity_type, :integer, default: 2
  		add_column :suppliers, :address, :string
  		add_column :suppliers, :number, :integer
  		add_column :suppliers, :complement, :string
  		add_column :suppliers, :zipcode, :string
  		add_column :suppliers, :burgh, :string
  		add_column :suppliers, :city, :string
  		add_column :suppliers, :state, :string
  		add_column :suppliers, :status, :boolean, default: true
  end
end
