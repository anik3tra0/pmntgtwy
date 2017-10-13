require 'digest'
require 'openssl'
require 'base64'
require 'json'

class ReceivePayment
	ENCRYPTION_KEY = 'Q9fbkBF8au24C9wshGRW9ut8ecYpyXye5vhFLtHFdGjRg3a4HxPYRfQaKutZx5N4'
	ENCRYPTION_IV = '\x81\xE6$\xA1rc+tk\x98.\xFB\x1EGl\xB1'

	def initialize(transaction)
		@transaction = JSON.parse(transaction).dig('msg')
	end

	def authorize
		verified? ? 'txn_status=success|' + decrypt + '|payment_gateway_transaction_reference=pg_txn_0001' : 'txn_status=failure|' + decrypt + '|payment_gateway_transaction_reference=pg_txn_0001'
	end

	private

	def decode_base64
		Base64.decode64(@transaction)
	end

	def decrypt
		decipher = OpenSSL::Cipher::AES128.new(:CBC)
		decipher.decrypt
		decipher.key = ENCRYPTION_KEY
		decipher.iv = ENCRYPTION_IV
		decipher.update(decode_base64) + decipher.final
	end

	def verified?
		split_hash = decrypt.split('|hash=')
		received_hash_key = split_hash[1]
		transaction_string = split_hash[0]
		this_hash_key = Digest::SHA1.hexdigest(transaction_string)
		this_hash_key === received_hash_key ? true : false
	end

end
