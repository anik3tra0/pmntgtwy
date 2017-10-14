[<img src="https://travis-ci.org/anik3tra0/pmntgtwy.svg?branch=master">]()

# PMNTGTWY

Client & Server Implementation of a payment transaction with encryption and encoding.

### Usage

```sh
gem install pry # If you don't have pry

pry -r ./lib/send_payment.rb
> sp = SendPayment.new({ bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' })
> sp.make
=> "txn_status=success|bank_ifsc_code=ANZB0001122|bank_account_number=1111222233334444|amount=105000|merchant_transaction_ref=txn001|transaction_date=2017-10-12|hash=aa440981747d01de3ac832f9fbf75626e684175c|payment_gateway_transaction_reference=pg_txn_0001"
```

### Todo

- [x] Send Payment Data Validation
- [x] Send Payment Data Validation Specs
- [ ] Edge Cases Handling
- [ ] Edge Cases Handling Specs
- [ ] ReceivePayment Specs
- [ ] More Usage Examples
