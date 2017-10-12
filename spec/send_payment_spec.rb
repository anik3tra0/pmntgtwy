require 'send_payment'
RSpec.describe SendPayment do
	context 'with a outward payment request' do

		before(:each) do
			transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
			@send_payment = SendPayment.new(transaction)
		end

		describe '#stringify' do
			it 'creates a pipe seperated string' do
				expect(@send_payment.send(:stringify)).to include('bank_ifsc_code', 'bank_account_number', 'amount', 'merchant_transaction_ref', 'transaction_date', 'payment_gateway_merchant_reference', '|')
			end
		end

		describe '#payload_with_hash' do
			it 'creates a hash of the pipe seperated string and appends it to the same string ' do
				expect(@send_payment.send(:payload_with_hash)).to include('bank_ifsc_code', 'bank_account_number', 'amount', 'merchant_transaction_ref', 'transaction_date', 'payment_gateway_merchant_reference', '|', 'hash')
			end
		end

		describe '#encrypted_payload' do
			it 'encrypts the pipe seperated string encodes it using base64' do
				expect(@send_payment.send(:encrypted_payload)).to match(/^(?:[A-Za-z0-9+\/]{4}\n?)*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$/)
			end
		end

		describe '#make' do
			it 'makes a transaction request to server and prints the response' do
				response = JSON.parse(@send_payment.make)
				expect(response.dig('msg')).to match(/^(?:[A-Za-z0-9+\/]{4}\n?)*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$/)
			end
		end

	end
end
