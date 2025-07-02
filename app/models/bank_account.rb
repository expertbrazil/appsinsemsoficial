class BankAccount < ApplicationRecord
	validates :name, :agency, :account_number, presence: true
	has_many :bills_pays
	has_many :bills_receifes

	# after_save :ensure_only_one_default

	LAYOUTS = [
    	["Bando do Brasil", 1],
    	["Santander", 2]
  	]

  	def to_h
	    result = {}

	    result[:cedente] = cedente
	    result[:documento_cedente] = cedente_doc
	    result[:cedente_endereco] = cedente_address if cedente_address.present?

	    result[:agencia] = agency
	    result[:conta_corrente] = account_number
	    result[:aceite] = aceite

	    result[:variacao] = variacao if variacao.present?
	    result[:carteira] = carteira if carteira.present?
	    result[:convenio] = convenio.to_i if convenio.present?

		result
	end

private
	def ensure_only_one_default
    	if self.default_bank?
      		Bank.where('id != ?', self.id).update_all("default_bank = 'false'")
    	end
  	end
end
