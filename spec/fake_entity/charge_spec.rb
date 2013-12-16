require 'spec_helper'
describe WebPay::Mock::FakeEntity::Charge do
  include WebPay::Mock::FakeEntity

  context 'params is empty' do
    subject(:charge) { charge_from({}) }

    specify { expect(charge['id']).to start_with 'ch_' }
    specify { expect(charge['object']).to eq 'charge' }
    specify { expect(charge['livemode']).to eq false }
    specify { expect(charge['created']).to be_within(2).of(Time.now.to_i) }
    specify { expect(charge['amount']).to eq 1000 }
    specify { expect(charge['card']).to be_a Hash }
    specify { expect(charge['currency']).to eq 'jpy' }
    specify { expect(charge['paid']).to eq true }
    specify { expect(charge['captured']).to eq true }
    specify { expect(charge['refunded']).to eq false }
    specify { expect(charge['amount_refunded']).to eq 0 }
    specify { expect(charge['customer']).to eq nil }
    specify { expect(charge['description']).to eq nil }
    specify { expect(charge['failure_message']).to eq nil }
    specify { expect(charge['expire_time']).to eq nil }

    subject(:card) { charge['card'] }
    specify { expect(card['object']).to eq 'card' }
    specify { expect(card['exp_year']).to eq 2014 }
    specify { expect(card['exp_month']).to eq 11 }
    specify { expect(card['fingerprint']).to be_a String }
    specify { expect(card['name']).to eq 'KEI KUBO' }
    specify { expect(card['type']).to eq 'Visa' }
    specify { expect(card['cvc_check']).to eq 'pass' }
    specify { expect(card['last4']).to eq '4242' }
  end

  context 'params has amount, currency, description, card' do
    let(:card_params) { {:number=>"4242-4242-4242-4242",
        :exp_month=>"10",
        :exp_year=>"2019",
        :cvc=>"123",
        :name=>"KIYOKI IPPYO"} }
    subject(:charge) { charge_from({amount: 100, currency: 'usd', description: 'desc', card: card_params}) }

    specify { expect(charge['amount']).to eq 100 }
    specify { expect(charge['currency']).to eq 'usd' }
    specify { expect(charge['description']).to eq 'desc' }

    subject(:card) { charge['card'] }
    specify { expect(card['object']).to eq 'card' }
    specify { expect(card['exp_year']).to eq '2019' }
    specify { expect(card['exp_month']).to eq '10' }
    specify { expect(card['fingerprint']).to be_a String }
    specify { expect(card['name']).to eq 'KIYOKI IPPYO' }
    specify { expect(card['type']).to eq 'Visa' }
    specify { expect(card['cvc_check']).to eq 'pass' }
    specify { expect(card['last4']).to eq '4242' }
  end

  context 'params has customer' do
    let(:customer_id) { 'cus_yyyyyyyyy' }
    subject(:charge) { charge_from(customer: customer_id) }

    specify { expect(charge['customer']).to eq customer_id }

    subject(:card) { charge['card'] }
    specify { expect(card['name']).to eq 'KEI KUBO' }
  end

  context 'capture is false' do
    subject(:charge) { charge_from(capture: false) }

    specify { expect(charge['captured']).to eq false }
    specify { expect(charge['paid']).to eq false }
    specify { expect(charge['expire_time']).to be_within(2).of(Time.now.to_i + 60 * 60 * 24 * 7) }
  end
end
