require 'spec_helper'
describe WebPay::Mock::FakeEntity::Customer do
  include WebPay::Mock::FakeEntity

  context 'params is empty' do
    subject(:customer) { customer_from({}) }

    specify { expect(customer['id']).to start_with 'cus_' }
    specify { expect(customer['object']).to eq 'customer' }
    specify { expect(customer['livemode']).to eq false }
    specify { expect(customer['created']).to be_within(2).of(Time.now.to_i) }
    specify { expect(customer['email']).to eq nil }
    specify { expect(customer['description']).to eq nil }
    specify { expect(customer['active_card']).to eq nil }
  end

  context 'email and description is given' do
    let(:email) { 'test@example.com' }
    let(:description) { 'desc' }
    subject(:customer) { customer_from(email: email, description: description) }

    specify { expect(customer['email']).to eq email }
    specify { expect(customer['description']).to eq description }
  end

  context 'card is hash' do
    let(:card_params) { {:number=>"4242-4242-4242-4242",
        :exp_month=>"10",
        :exp_year=>"2019",
        :cvc=>"123",
        :name=>"KIYOKI IPPYO"} }
    subject(:card) { customer_from(card: card_params)['active_card'] }

    specify { expect(card['object']).to eq 'card' }
    specify { expect(card['exp_year']).to eq '2019' }
    specify { expect(card['exp_month']).to eq '10' }
    specify { expect(card['fingerprint']).to be_a String }
    specify { expect(card['name']).to eq 'KIYOKI IPPYO' }
    specify { expect(card['type']).to eq 'Visa' }
    specify { expect(card['cvc_check']).to eq 'pass' }
    specify { expect(card['last4']).to eq '4242' }
  end

  context 'card is token' do
    subject(:card) { customer_from(card: 'tok_xxxxxxxxxxxx')['active_card'] }

    specify { expect(card['object']).to eq 'card' }
    specify { expect(card['exp_year']).to eq 2014 }
    specify { expect(card['exp_month']).to eq 11 }
    specify { expect(card['fingerprint']).to be_a String }
    specify { expect(card['name']).to eq 'KEI KUBO' }
    specify { expect(card['type']).to eq 'Visa' }
    specify { expect(card['cvc_check']).to eq 'pass' }
    specify { expect(card['last4']).to eq '4242' }
  end
end
