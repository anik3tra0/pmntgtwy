require 'receive_payment'
require 'send_payment'
RSpec.describe ReceivePayment do
	context 'with a inward payment request' do

		before(:each) do
			transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
			send_payment = SendPayment.new(transaction)
			payload = send_payment.send(:fake)
			@receive_payment = ReceivePayment.new(payload)
		end

		describe '#decode_base64' do
			skip 'base64 decodes the payload' do
				expect(@receive_payment.send(:decode_base64)).to include('|bank_ifsc_code', '|bank_account_number', '|amount', '|merchant_transaction_ref', '|transaction_date', '|payment_gateway_merchant_reference')
			end
		end

		describe '#decrypt' do
			skip 'decrypts the cipher and reduces to string ' do
				expect(@send_payment.send(:payload_with_hash)).to include('bank_ifsc_code', 'bank_account_number', 'amount', 'merchant_transaction_ref', 'transaction_date', 'payment_gateway_merchant_reference', '|', 'hash')
			end
		end

		describe '#encrypted_payload' do
			skip 'encrypts the pipe seperated string encodes it using base64' do
				expect(@send_payment.send(:encrypted_payload)).to match(/^(?:[A-Za-z0-9+\/]{4}\n?)*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$/)
			end
		end

		describe '#make' do
			skip 'makes a transaction request to server and prints the response' do
				response = JSON.parse(@send_payment.make)
				expect(response.dig('msg')).to match(/^(?:[A-Za-z0-9+\/]{4}\n?)*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$/)
			end
		end

	end
end
