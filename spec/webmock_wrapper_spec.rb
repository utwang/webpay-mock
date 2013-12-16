require 'spec_helper'
require 'webpay'

describe WebPay::Mock::WebMockWrapper do
  # In RSpec:
  #
  #     RSpec.configure do |c|
  #       c.include WebPay::Mock::WebMockWrapper
  #     end
  include WebPay::Mock::WebMockWrapper

  describe 'charges' do
    describe 'create' do
      let(:params) { { amount: 1000, currency: 'jpy', card: 'tok_xxxxxxxxx', description: 'test charge' } }
      let!(:response) { webpay_stub(:charges, :create, params: params) }

      specify { expect(WebPay::Charge.create(params).id).to eq response['id'] }
    end

    describe 'retrieve' do
      let(:id) { 'ch_xxxxxxxxx' }
      before { webpay_stub(:charges, :retrieve, id: id) }
      specify { expect(WebPay::Charge.retrieve(id).id).to eq id }
    end

    describe 'refund' do
      let(:id) { 'ch_xxxxxxxxx' }
      let!(:retrieved) { webpay_stub(:charges, :retrieve, id: id) }
      let!(:refunded) { webpay_stub(:charges, :refund, params: { 'amount' => retrieved['amount'] }, base: retrieved) }
      specify { expect(WebPay::Charge.retrieve(id).refund.refunded).to eq true }
    end

    describe 'capture' do
      let(:id) { 'ch_xxxxxxxxx' }
      let!(:retrieved) { webpay_stub(:charges, :retrieve, id: id, overrides: { captured: false } ) }
      let!(:captured) { webpay_stub(:charges, :capture, base: retrieved) }
      specify { expect(WebPay::Charge.retrieve(id).captured).to eq false }
      specify { expect(WebPay::Charge.retrieve(id).capture.captured).to eq true }
    end

    describe 'all' do
      before { webpay_stub(:charges, :all) }
      specify { expect(WebPay::Charge.all.count).to eq 3 }
    end
  end

  describe 'customers' do
    describe 'create' do
      let!(:response) { webpay_stub(:customers, :create, params: {}) }
      specify { expect(WebPay::Customer.create({}).id).to eq response['id'] }
    end

    describe 'retrieve' do
      let(:id) { 'cus_xxxxxxxxx' }
      before { webpay_stub(:customers, :retrieve, id: id) }
      specify { expect(WebPay::Customer.retrieve(id).id).to eq id }
    end

    describe 'update' do
      let(:id) { 'cus_xxxxxxxxx' }
      let!(:retrieved) { webpay_stub(:customers, :retrieve, id: id) }
      let!(:updated) { webpay_stub(:customers, :update, params: { 'email' => 'new@example.com' }, base: retrieved) }
      specify do
        customer = WebPay::Customer.retrieve(id)
        customer.email = 'new@example.com'
        customer.save
        expect(customer.email).to eq 'new@example.com'
      end
    end

    describe 'delete' do
      let(:id) { 'cus_xxxxxxxxx' }
      let!(:retrieved) { webpay_stub(:customers, :retrieve, id: id) }
      let!(:updated) { webpay_stub(:customers, :delete, id: id) }
      specify do
        customer = WebPay::Customer.retrieve(id)
        expect(customer.delete).to eq true
      end
    end

    describe 'all' do
      before { webpay_stub(:customers, :all) }
      specify { expect(WebPay::Customer.all.count).to eq 3 }
    end
  end

  describe 'token' do
    describe 'create' do
      let(:card_params) { {:number=>"4242-4242-4242-4242",
          :exp_month=>"10",
          :exp_year=>"2019",
          :cvc=>"123",
          :name=>"KIYOKI IPPYO"} }
      let!(:response) { webpay_stub(:tokens, :create, params: card_params) }
      specify { expect(WebPay::Token.create(card: card_params).id).to eq response['id'] }
    end

    describe 'retrieve' do
      let(:id) { 'tok_xxxxxxxxx' }
      before { webpay_stub(:tokens, :retrieve, id: id) }
      specify { expect(WebPay::Token.retrieve(id).id).to eq id }
    end
  end

  describe 'events' do
    describe 'retrieve' do
      let(:id) { 'evt_xxxxxxxxx' }
      before { webpay_stub(:events, :retrieve, id: id) }
      specify { expect(WebPay::Event.retrieve(id).id).to eq id }
    end

    describe 'all' do
      before { webpay_stub(:events, :all) }
      specify { expect(WebPay::Event.all.count).to eq 3 }
    end
  end

  describe 'account' do
    describe 'retrieve' do
      before { webpay_stub(:account, :retrieve) }
      specify { expect(WebPay::Account.retrieve.id).to start_with 'acct_' }
    end

    describe 'delete_data' do
      before { webpay_stub(:account, :delete_data) }
      specify { expect(WebPay::Account.delete_data).to eq true }
    end
  end
end
