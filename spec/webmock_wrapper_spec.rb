require 'spec_helper'
require 'webpay'

describe WebPay::Mock::WebMockWrapper do
  # In RSpec:
  #
  #     RSpec.configure do |c|
  #       c.include WebPay::Mock::WebMockWrapper
  #     end
  include WebPay::Mock::WebMockWrapper
  let(:webpay) { WebPay.new('test_secret_xxxxxx') }

  describe 'charges' do
    describe 'create' do
      let(:params) { { amount: 1000, currency: 'jpy', card: 'tok_xxxxxxxxx', description: 'test charge' } }
      let!(:response) { webpay_stub(:charges, :create, params: params) }

      specify { expect(webpay.charge.create(params).id).to eq response['id'] }
    end

    describe 'create responds card error' do
      let(:params) { { amount: 1000, currency: 'jpy', card: 'tok_xxxxxxxxx', description: 'test charge' } }
      let!(:response) { webpay_stub(:charges, :create, error: :card_error, params: params) }

      specify { expect { webpay.charge.create(params).id }.to raise_error(WebPay::ErrorResponse::CardError) }
    end

    describe 'create responds card error with specified cause' do
      let(:params) { { amount: 1000, currency: 'jpy', card: 'tok_xxxxxxxxx', description: 'test charge' } }
      let!(:response) { webpay_stub(:charges, :create, params: params, response: card_error(
            message: "You must provide the card which is not expired",
            caused_by: "buyer",
            param: "exp_month",
            code: "invalid_expiry_month"
            )) }

      specify { expect { webpay.charge.create(params).id }.to raise_error { |e|
          expect(e.data.error.caused_by).to eq 'buyer'
          expect(e.data.error.code).to eq 'invalid_expiry_month'
        } }
    end

    describe 'retrieve' do
      let(:id) { 'ch_xxxxxxxxx' }
      before { webpay_stub(:charges, :retrieve, id: id) }
      specify { expect(webpay.charge.retrieve(id).id).to eq id }
    end

    describe 'retrieve responds not found' do
      let(:params) { { amount: 1000, currency: 'jpy', card: 'tok_xxxxxxxxx', description: 'test charge' } }
      let!(:response) { webpay_stub(:charges, :create, error: :not_found, params: params) }

      specify { expect { webpay.charge.create(params).id }.to raise_error(WebPay::ErrorResponse::InvalidRequestError) }
    end

    describe 'refund' do
      let(:id) { 'ch_xxxxxxxxx' }
      let(:data) { charge_from({amount: 5000}, id: id) }
      let!(:refunded) { webpay_stub(:charges, :refund, params: { 'amount' => data['amount'] }, base: data) }
      specify { expect(webpay.charge.refund(id).refunded).to eq true }
    end

    describe 'capture' do
      let(:id) { 'ch_xxxxxxxxx' }
      let!(:captured) { webpay_stub(:charges, :capture, params: { id: id }) }
      specify { expect(webpay.charge.capture(id).captured).to eq true }
    end

    describe 'all' do
      before { webpay_stub(:charges, :all) }
      specify { expect(webpay.charge.all.count).to eq 3 }
    end
  end

  describe 'customers' do
    describe 'create' do
      let!(:response) { webpay_stub(:customers, :create, params: {}) }
      specify { expect(webpay.customer.create({}).id).to eq response['id'] }
    end

    describe 'retrieve' do
      let(:id) { 'cus_xxxxxxxxx' }
      before { webpay_stub(:customers, :retrieve, id: id) }
      specify { expect(webpay.customer.retrieve(id).id).to eq id }
    end

    describe 'update' do
      let(:id) { 'cus_xxxxxxxxx' }
      let!(:updated) { webpay_stub(:customers, :update, params: { 'email' => 'new@example.com', 'id' => id }) }
      specify do
        response = webpay.customer.update(id: id, email: 'new@example.com')
        expect(response.email).to eq 'new@example.com'
      end
    end

    describe 'delete' do
      let(:id) { 'cus_xxxxxxxxx' }
      let!(:updated) { webpay_stub(:customers, :delete, id: id) }
      specify do
        customer = webpay.customer.delete(id)
        expect(customer.deleted).to eq true
      end
    end

    describe 'all' do
      before { webpay_stub(:customers, :all) }
      specify { expect(webpay.customer.all.count).to eq 3 }
    end

    describe 'delete_active_card' do
      let(:id) { 'cus_xxxxxxxxx' }
      let!(:updated) { webpay_stub(:customers, :delete_active_card, id: id) }
      specify do
        response = webpay.customer.delete_active_card(id: id)
        expect(response.id).to eq id
        expect(response.active_card).to be_nil
      end
    end
  end

  describe 'recursios' do
    describe 'create' do
      let(:params) { { amount: 1000, currency: 'jpy', customer: 'cus_xxxxxxxxx', period: 'month', description: 'test charge' } }
      let!(:response) { webpay_stub(:recursion, :create, params: params) }
      specify { expect(webpay.recursion.create({}).id).to eq response['id'] }
    end

    describe 'retrieve' do
      let(:id) { 'rec_xxxxxxxxx' }
      before { webpay_stub(:recursions, :retrieve, id: id) }
      specify { expect(webpay.recursion.retrieve(id).id).to eq id }
    end

    describe 'resume' do
      let(:id) { 'rec_xxxxxxxxx' }
      let!(:retrieved) { webpay_stub(:recursions, :retrieve, id: id, overrides: { status: 'suspended' }) }
      let!(:resumed) { webpay_stub(:recursions, :resume, base: retrieved) }
      specify { expect(webpay.recursion.retrieve(id).status).to eq 'suspended' }
      specify { expect(webpay.recursion.resume(id).status).to eq 'active' }
    end

    describe 'delete' do
      let(:id) { 'rec_xxxxxxxxx' }
      let!(:updated) { webpay_stub(:recursions, :delete, id: id) }
      specify do
        recursion = webpay.recursion.delete(id)
        expect(recursion.deleted).to eq true
      end
    end

    describe 'all' do
      before { webpay_stub(:recursions, :all) }
      specify { expect(webpay.recursion.all.count).to eq 3 }
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
      specify { expect(webpay.token.create(card: card_params).id).to eq response['id'] }
    end

    describe 'retrieve' do
      let(:id) { 'tok_xxxxxxxxx' }
      before { webpay_stub(:tokens, :retrieve, id: id) }
      specify { expect(webpay.token.retrieve(id).id).to eq id }
    end
  end

  describe 'events' do
    describe 'retrieve' do
      let(:id) { 'evt_xxxxxxxxx' }
      before { webpay_stub(:events, :retrieve, id: id) }
      specify { expect(webpay.event.retrieve(id).id).to eq id }
    end

    describe 'all' do
      before { webpay_stub(:events, :all) }
      specify { expect(webpay.event.all.count).to eq 3 }
    end
  end

  describe 'account' do
    describe 'retrieve' do
      before { webpay_stub(:account, :retrieve) }
      specify { expect(webpay.account.retrieve.id).to start_with 'acct_' }
    end

    describe 'delete_data' do
      before { webpay_stub(:account, :delete_data) }
      specify { expect(webpay.account.delete_data.deleted).to eq true }
    end
  end
end
