require 'send_payment'
RSpec.describe SendPayment do
	context 'with a outward payment request' do

		describe '#stringify' do
			it 'creates a pipe seperated string' do
				transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				send_payment = SendPayment.new(transaction)
				expect(send_payment.send(:stringify)).to include('bank_ifsc_code', 'bank_account_number', 'amount', 'merchant_transaction_ref', 'transaction_date', 'payment_gateway_merchant_reference', '|')
			end
		end

	end
end
