require 'spec_helper'
describe WebPay::Mock::FakeEntity::Account do
  include WebPay::Mock::FakeEntity

  describe 'default' do
    subject(:account) { fake_account }
    specify { expect(account['id']).to start_with 'acct_' }
    specify { expect(account['object']).to eq 'account' }
    specify { expect(account['charge_enabled']).to eq false }
    specify { expect(account['currencies_supported']).to eq ['jpy'] }
    specify { expect(account['details_submitted']).to eq false }
    specify { expect(account['email']).to eq 'test@example.com' }
    specify { expect(account['statement_descriptor']).to eq nil }
  end
end
