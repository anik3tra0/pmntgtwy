require 'digest'
require 'openssl'
require 'base64'
require 'uri'
require 'net/http'
require 'json'
require './lib/receive_payment'

class SendPayment
	attr_reader :transaction
	ENCRYPTION_KEY = 'Q9fbkBF8au24C9wshGRW9ut8ecYpyXye5vhFLtHFdGjRg3a4HxPYRfQaKutZx5N4'
	ENCRYPTION_IV = '\x81\xE6$\xA1rc+tk\x98.\xFB\x1EGl\xB1'
	URL = URI("https://somebank.com/transaction")
	HASH_KEYS = [:bank_ifsc_code, :bank_account_number, :amount, :merchant_transaction_ref, :transaction_date, :payment_gateway_merchant_reference].freeze

	def initialize(transaction)
		@transaction = transaction
	end

	def make
		if is_valid?
			http = Net::HTTP.new(URL.host, URL.port)

			request = Net::HTTP::Post.new(URL)
			request['content-type'] = 'application/json'
			request.body = { msg: encrypted_payload }
			request.body = request.body.to_json

			# response = http.request(request)
			# puts request.body
			ReceivePayment.new(request.body).authorize
		else
			'Invalid Transaction'
		end
	end

	private

	def stringify
		(@transaction.map { |k, v| "#{k}=#{v}" }).join('|')
	end

	def payload_with_hash
		hash = Digest::SHA1.hexdigest(stringify)
		stringify + "|hash=#{hash}"
	end

	def encrypted_payload
		cipher = OpenSSL::Cipher::AES128.new(:CBC)
		cipher.encrypt
		cipher.key = ENCRYPTION_KEY
		cipher.iv = ENCRYPTION_IV
		encrypted_payload = cipher.update(payload_with_hash) + cipher.final
		Base64.encode64(encrypted_payload)
	end

	def fake
		payload = { msg: encrypted_payload }
		payload.to_json
	end

	def valid_keys?
		HASH_KEYS.all? { |s| @transaction.key? s }
	end

	def valid_values?
		!@transaction.values.any?(&:empty?)
	end

	def valid_bank_account_number?
		@transaction.dig(:bank_account_number) =~ /^[0-9]{9,18}|(?=a)b/ ? true : false
	end

	def valid_bank_ifsc_code?
		@transaction.dig(:bank_ifsc_code) =~ /^[A-Za-z]{4}\d{7}$|(?=a)b/ ? true : false
	end

	def valid_amount?
		@transaction.dig(:amount).to_i.positive?
	end

	def valid_merchant_txn_ref?
		@transaction.dig(:merchant_transaction_ref) =~ /^(txn){0,3}[0-9]*/ ? true : false
	end

	def valid_txn_date?
		@transaction.dig(:transaction_date) =~ /^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$/ ? true : false
	end

	def pmt_gtwy_merchant_ref?
		@transaction.dig(:payment_gateway_merchant_reference) =~ /^(merc){0,4}[0-9]*/ ? true : false
	end

	def is_valid?
		checkbox = [
			valid_keys?,
			valid_values?,
			valid_bank_account_number?,
			valid_bank_ifsc_code?,
			valid_amount?,
			valid_merchant_txn_ref?,
			valid_txn_date?,
			pmt_gtwy_merchant_ref?
		]
		checkbox.include?(false) ? false : true
	end

end
