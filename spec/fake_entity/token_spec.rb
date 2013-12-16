require 'spec_helper'
describe WebPay::Mock::FakeEntity::Token do
  include WebPay::Mock::FakeEntity

  context 'params is empty' do
    subject(:token) { token_from({}) }

    specify { expect(token['id']).to start_with 'tok_' }
    specify { expect(token['object']).to eq 'token' }
    specify { expect(token['livemode']).to eq false }
    specify { expect(token['created']).to be_within(2).of(Time.now.to_i) }
    specify { expect(token['card']).to be_a Hash }
    specify { expect(token['used']).to eq false }

    subject(:card) { token['card'] }
    specify { expect(card['object']).to eq 'card' }
    specify { expect(card['exp_year']).to eq 2014 }
    specify { expect(card['exp_month']).to eq 11 }
    specify { expect(card['fingerprint']).to be_a String }
    specify { expect(card['name']).to eq 'KEI KUBO' }
    specify { expect(card['type']).to eq 'Visa' }
    specify { expect(card['cvc_check']).to eq 'pass' }
    specify { expect(card['last4']).to eq '4242' }
  end

  context 'params has card' do
    let(:card_params) { {:number=>"4242-4242-4242-9898",
        :exp_month=>"10",
        :exp_year=>"2019",
        :cvc=>"123",
        :name=>"KIYOKI IPPYO"} }
    subject(:card) { token_from({card: card_params})['card'] }

    specify { expect(card['exp_year']).to eq '2019' }
    specify { expect(card['exp_month']).to eq '10' }
    specify { expect(card['name']).to eq 'KIYOKI IPPYO' }
    specify { expect(card['last4']).to eq '9898' }
  end
end
