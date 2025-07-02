class AddColumnIdadeLimiteEstudanteToCustomerConfigurations < ActiveRecord::Migration[5.0]
  def change
  	add_column :customer_configurations, :idade_limite_estudante, :integer, default: 24
  	add_column :customer_configurations, :signature, :string
  end
end
