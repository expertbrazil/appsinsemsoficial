# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Role.all.size ==  0
	@role = Role.create(name: "Administradores", permissions: [:module_roles,:manager_roles])
	@user = User.create(email: "jeffersonwpu@gmail.com", username: "Jefferson", password: "sinsens2016", password_confirmation: "sinsens2016")
	@user.role_users.create(role_id: @role.id)
end


if CustomerConfiguration.current.nil?
	@customer_configuration = CustomerConfiguration.new(
		name: "Sindicato",
		ficha: "<p>Autorizo o desconto em folha de pagamento do percentual de 2% (dois por cento) referente à mensalidade sindical em favor do NomeDoSindicato.</p>"
	)

	@customer_configuration.save(validate: false)
end