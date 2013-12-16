require 'spec_helper'
describe WebPay::Mock::FakeEntity::Event do
  include WebPay::Mock::FakeEntity

  describe 'default' do
    subject(:event) { fake_event }
    specify { expect(event['id']).to start_with 'evt_' }
    specify { expect(event['object']).to eq 'event' }
    specify { expect(event['livemode']).to eq false }
    specify { expect(event['created']).to be_within(2).of(Time.now.to_i) }
    specify { expect(event['data']).to be_a Hash }
    specify { expect(event['pending_webhooks']).to eq 0 }
    specify { expect(event['type']).to eq 'charge.created' }

    subject(:data) { event['data'] }
    specify { expect(data['object']['object']).to eq 'charge' }
    specify { expect(data['previous_attributes']).to eq nil }
  end

  describe 'override for customer.updated event' do
    let(:customer) { customer_from(email: 'test@example.com') }
    let(:previous) { { 'email' => 'old@example.com' } }
    subject(:event) { fake_event(data: { 'object' => customer, 'previous_attributes' => previous }) }

    subject(:data) { event['data'] }
    specify { expect(data['object']).to eq customer }
    specify { expect(data['previous_attributes']).to eq previous }
  end
end
