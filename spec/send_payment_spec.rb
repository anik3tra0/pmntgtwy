require 'send_payment'
RSpec.describe SendPayment do
	context 'with a valid outward payment request' do

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
				expect(@send_payment.make).to include('|bank_ifsc_code', '|bank_account_number', '|amount', '|merchant_transaction_ref', '|transaction_date', '|payment_gateway_merchant_reference', '|payment_gateway_transaction_reference', '|hash')
			end
		end

		describe '#valid_keys?' do
			it 'checks if transaction has valid keys' do
				expect(@send_payment.send(:valid_keys?)).to be_truthy
			end
		end

		describe '#valid_values?' do
			it 'checks if transaction has valid values' do
				expect(@send_payment.send(:valid_values?)).to be_truthy
			end
		end

		describe '#valid_bank_account_number?' do
			it 'checks if transaction has valid bank account number' do
				expect(@send_payment.send(:valid_bank_account_number?)).to be_truthy
			end
		end

		describe '#valid_bank_ifsc_code?' do
			it 'checks if transaction has valid bank IFSC code' do
				expect(@send_payment.send(:valid_bank_ifsc_code?)).to be_truthy
			end
		end

		describe '#valid_amount?' do
			it 'checks if transaction has valid amount' do
				expect(@send_payment.send(:valid_amount?)).to be_truthy
			end
		end

		describe '#valid_merchant_txn_ref?' do
			it 'checks if transaction has valid merchant transaction reference' do
				expect(@send_payment.send(:valid_merchant_txn_ref?)).to be_truthy
			end
		end

		describe '#valid_txn_date?' do
			it 'checks if transaction has valid transaction date' do
				expect(@send_payment.send(:valid_txn_date?)).to be_truthy
			end
		end

		describe '#pmt_gtwy_merchant_ref?' do
			it 'checks if transaction has valid payment gateway merchant reference' do
				expect(@send_payment.send(:pmt_gtwy_merchant_ref?)).to be_truthy
			end
		end

		describe '#is_valid?' do
			it 'checks if transaction hash is valid' do
				expect(@send_payment.send(:is_valid?)).to be_truthy
			end
		end

	end

	context 'In a Invalid Payment Request Scenario' do

		describe 'in case of a invalid transaction' do
			it 'checks if any key is missing then transaction should fail' do
				transaction = { amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.make).to match 'Invalid Transaction'
			end

			it 'checks if all keys are missing then transaction should fail' do
				transaction = {}
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.make).to match('Invalid Transaction')
			end

			it 'checks if any value is missing then transaction should fail' do
				transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: '', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.make).to match('Invalid Transaction')
			end

			it 'fails makes a transaction request to server and prints Invalid Transaction' do
				transaction = { bank_ifsc_code: '', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: '', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.make).to include('Invalid Transaction')
			end

			it 'fails if transaction has invalid keys' do
				transaction = { blah_bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: '001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:valid_keys?)).to be_falsy
			end

			it 'fails if transaction has empty values' do
				transaction = { bank_ifsc_code: '', bank_account_number: '11112222333344445555', amount: '105000', merchant_transaction_ref: '', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:valid_values?)).to be_falsy
			end

			it 'fails if transaction has invalid bank account number' do
				transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '11112222333344445555', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:valid_bank_account_number?)).to be_falsy
			end

			it 'fails if transaction has invalid bank IFSC code' do
				transaction = { bank_ifsc_code: 'ANZB000AB22', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:valid_bank_ifsc_code?)).to be_falsy
			end


			it 'fails if transaction has invalid amount' do
				transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: 'ABS123', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:valid_amount?)).to be_falsy
			end

			it 'fails if transaction has invalid merchant transaction reference' do
				transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'abc', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:valid_merchant_txn_ref?)).to be_falsy
			end

			it 'fails if transaction has invalid transaction date' do
				transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '12123-10-2017', payment_gateway_merchant_reference: 'merc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:valid_txn_date?)).to be_falsy
			end

			it 'fails if transaction has invalid payment gateway merchant reference' do
				transaction = { bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '12123-10-2017', payment_gateway_merchant_reference: 'abc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:pmt_gtwy_merchant_ref?)).to be_falsy
			end

			it 'fails if transaction is invalid' do
				transaction = { bank_account_number: '1111222233334444123123', amount: '0', merchant_transaction_ref: 'abc001', transaction_date: '12123-10-2017', payment_gateway_merchant_reference: 'abc001' }
				@send_payment = SendPayment.new(transaction)
				expect(@send_payment.send(:is_valid?)).to be_falsy
			end
		end

	end
end
