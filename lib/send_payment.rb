class SendPayment
	def initialize(transaction)
		@transaction = transaction
	end

	private

	def stringify
		(@transaction.map { |k, v| "#{k}=#{v}" }).join('|')
	end
end
