require 'spec_helper'

describe WebPay::Mock::FakeEntity::Recursion do
  include WebPay::Mock::FakeEntity

  context 'params is empty' do
    subject(:recursion) { recursion_from({}) }

    specify { expect(recursion['id']).to start_with 'rec_' }
    specify { expect(recursion['object']).to eq 'recursion' }
    specify { expect(recursion['livemode']).to eq false }
    specify { expect(recursion['created']).to be_within(2).of(Time.now.to_i) }
    specify { expect(recursion['amount']).to eq 400 }
    specify { expect(recursion['currency']).to eq 'jpy' }
    specify { expect(recursion['period']).to eq 'month' }
    specify { expect(recursion['customer']).to eq 'cus_XXXXXXXXX' }
    specify { expect(recursion['last_executed']).to be_within(2).of(Time.now.to_i) }
    specify { expect(recursion['next_scheduled']).to be_within(2).of(Time.now.to_i + 30 * 24 * 60 * 60) }
    specify { expect(recursion['status']).to eq 'active' }
  end

  context 'params has amount, currency, customer, description' do
    let(:amount) { 100 }
    let(:currency) { 'usd' }
    let(:customer) { 'cus_YYYYYYYY' }
    let(:description) { 'desc' }

    subject(:recursion) do
      recursion_from(amount: amount, currency: currency, customer: customer, description: description)
    end

    specify { expect(recursion['amount']).to eq amount }
    specify { expect(recursion['currency']).to eq currency }
    specify { expect(recursion['customer']).to eq customer }
    specify { expect(recursion['description']).to eq description }
  end

  context 'params period or first_scheduled' do
    subject(:recursion) do
      recursion_from(period: period, first_scheduled: first_scheduled)
    end

    context 'params has period and first_scheduled' do
      let(:period) { 'year' }
      let(:first_scheduled) { Time.now.to_i + 60 * 60 * 24 * 10 }

      specify { expect(recursion['period']).to eq 'year' }
      specify { expect(recursion['last_executed']).to eq nil }
      specify { expect(recursion['next_scheduled']).to eq(first_scheduled) }
    end
  end
end
