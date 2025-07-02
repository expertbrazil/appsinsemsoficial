class CreateCustomerConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :customer_configurations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :cnpj
      t.string :street
      t.string :phone
      t.string :cell_phone
      t.date :date_fundation
      t.string :logo
      t.string :president
      t.text :ficha#, default: "<p>Autorizo o desconto em folha de pagamento do percentual de 2% (dois por cento) referente à mensalidade sindical em favor do NomeDoSindicato.</p>"
      t.string :menu_people_associateds, default: "Filiados"
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
