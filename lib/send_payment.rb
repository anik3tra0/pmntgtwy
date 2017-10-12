require 'digest'
require 'openssl'
require 'base64'
require 'uri'
require 'net/http'
require 'json'

class SendPayment
	ENCRYPTION_KEY = 'Q9fbkBF8au24C9wshGRW9ut8ecYpyXye5vhFLtHFdGjRg3a4HxPYRfQaKutZx5N4'
	ENCRYPTION_IV = '\x81\xE6$\xA1rc+tk\x98.\xFB\x1EGl\xB1'
	URL = URI("https://somebank.com/transaction")

	def initialize(transaction)
		@transaction = transaction
	end

	def make
		http = Net::HTTP.new(URL.host, URL.port)

		request = Net::HTTP::Post.new(URL)
		request["content-type"] = 'application/json'
		request.body = { msg: encrypted_payload }
		request.body = request.body.to_json
		#
		# response = http.request(request)
		# puts request.body
		request.body
	end

	private

	def stringify
		(@transaction.map { |k, v| "#{k}=#{v}" }).join('|')
	end

	def payload_with_hash
		hash = Digest::SHA1.hexdigest(stringify)
		stringify + "hash=#{hash}"
	end

	def encrypted_payload
		cipher = OpenSSL::Cipher::AES128.new(:CBC)
		cipher.encrypt
		cipher.key = ENCRYPTION_KEY
		cipher.iv = ENCRYPTION_IV
		encrypted_payload = cipher.update(payload_with_hash) + cipher.final
		Base64.encode64(encrypted_payload)
	end

end
