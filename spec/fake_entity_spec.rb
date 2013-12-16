require 'spec_helper'
describe WebPay::Mock::FakeEntity do
  include WebPay::Mock::FakeEntity

  describe 'fake_list' do
    subject(:list) { i = 0; fake_list('/numbers', lambda { i += 1 }) }
    specify { expect(list['object']).to eq 'list' }
    specify { expect(list['url']).to eq '/v1/numbers' }
    specify { expect(list['count']).to eq 3 }
    specify { expect(list['data']).to eq [1, 2, 3] }
  end
end
