json.array!(@people_associateds) do |people_associated|
  json.id people_associated[:id]
  json.name people_associated[:name]
  json.number_registration people_associated[:number_registration] 
  json.email people_associated[:email] 
  json.phone people_associated[:phone] 
  json.address people_associated[:address] 
  json.cpf people_associated[:cpf] 
  json.rg people_associated[:rg]
  json.type people_associated[:type]
end

