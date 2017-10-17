[![Build Status](https://travis-ci.org/anik3tra0/pmntgtwy.svg?branch=master)](https://travis-ci.org/anik3tra0/pmntgtwy)
[![Maintainability](https://api.codeclimate.com/v1/badges/07dc716514f2f81693bf/maintainability)](https://codeclimate.com/github/anik3tra0/pmntgtwy/maintainability)

# PMNTGTWY

Client & Server Implementation of a payment transaction with encryption and encoding.

## Class: SendPayment

Send Payment is a class that takes in one argument of fixed set of values called transaction. Transaction is a payment request that contains Bank IFSC Code, Bank Account Number, Amount, Merchant Transaction Reference, Transaction Date & Payment Gateway Merchant Reference.

### Constructor Details
`#initialize(transaction) ⇒ SendPayment`

Returns a new instance of SendPayment

### Instance Method Details
`#make ⇒ Struct`

## Class: ReceivePayment

### Constructor Details
`#initialize(transaction) ⇒ ReceivePayment`

Returns a new instance of ReceivePayment

Receive Payment is a class that takes in one argument of fixed set of values called transaction. Transaction is a payment request that Send Payment Object makes. It contains Bank IFSC Code, Bank Account Number, Amount, Merchant Transaction Reference, Transaction Date & Payment Gateway Merchant Reference along with a SHA1 Digest of the entire Payload.

### Instance Method Details
`#authorize ⇒ JSON`

### Usage

```sh
gem install pry # If you don't have pry

pry -r ./lib/send_payment.rb
> sp = SendPayment.new({ bank_ifsc_code: 'ANZB0001122', bank_account_number: '1111222233334444', amount: '105000', merchant_transaction_ref: 'txn001', transaction_date: '2017-10-12', payment_gateway_merchant_reference: 'merc001' })
> sp.make
=> #<OpenStruct data="txn_status=success|bank_ifsc_code=ANZB0001122|bank_account_number=1111222233334444|amount=105000|merchant_transaction_ref=txn001|transaction_date=2017-10-12|payment_gateway_merchant_reference=merc001|hash=7c477a30ef756e1f29d3a4978a7c088a4b2a4c6c|payment_gateway_transaction_reference=pg_txn_0001">
```

### Todo

- [x] Send Payment Data Validation
- [x] Send Payment Data Validation Specs
- [x] Send Payment Edge Cases Handling
- [x] Send Payment Edge Cases Handling Specs
- [ ] Receive Payment Specs
- [ ] Receive Payment Data Validation Specs
- [ ] Receive Payment Edge Cases Handling
- [ ] Receive Payment Edge Cases Handling Specs
- [ ] Documentation && More Usage Examples
