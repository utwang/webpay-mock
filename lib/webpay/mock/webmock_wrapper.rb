require 'webmock'
require 'json'

module WebPay::Mock::WebMockWrapper
  include WebPay::Mock::Util
  include WebPay::Mock::FakeEntity
  include WebPay::Mock::FakeError
  include WebMock::API

  # Wrapper of "WebMock::API::stub_request()".
  # This provides simple stubbing. Use "stub_request()" and fake response generators to control details.
  #
  # @param [String|Symbol] entity Entity type. One of charges, customers, tokens, events, account
  # @param [String|Symbol] action Action, such as create, retrieve, update, all
  # @param [Hash] options Specifies parameters for request and response.
  # @option option [Hash] base Base object, e.g. the retrieved object on which update is called. Used only in update-like actions.
  # @option option [Hash] params Request parameters (asserted using "with")
  # @option option [Hash] overrides Additional parameters to override response attributes
  # @option option [String] id Id to be included in the path
  # @option option [String] base_url Default is 'https://api.webpay.jp/v1'
  # @option option [Symbol] error Error type to return as the response
  # @return [Hash] object to be returned as JSON
  def webpay_stub(entity, action, options = {})
    base = options.delete(:base) || {}
    params = stringify_keys(options.delete(:params) || {})
    overrides = options.delete(:overrides) || {}
    id = params.delete('id') || options.delete(:id) || base['id']
    base_url = options[:base_url] || 'https://api.webpay.jp/v1'

    method, path, response =
      case entity.to_sym
      when :charge, :charges
        case action.to_sym
        when :create
          [:post, '/charges', charge_from(params, overrides)]
        when :retrieve
          [:get, '/charges/:id', charge_from({}, { id: id }.merge(overrides))]
        when :refund
          change = { 'id' => id, 'amount_refunded' => params['amount'] }
          change['refunded'] = !(params['amount'] && base['amount'] && params['amount'] != base['amount'])
          [:post, '/charges/:id/refund', charge_from({}, change.merge(overrides), base)]
        when :capture
          [:post, '/charges/:id/capture',
          charge_from({}, { 'id' => id, 'paid' => true, 'captured' => true }.merge(overrides), base)]
        when :all
          [:get, '/charges', fake_list('/charges', lambda { charge_from({}, overrides) })]
        end
      when :customer, :customers
        case action.to_sym
        when :create
          [:post, '/customers', customer_from(params, overrides)]
        when :retrieve
          [:get, '/customers/:id', customer_from({}, { id: id }.merge(overrides))]
        when :update
          [:post, '/customers/:id', customer_from(params, overrides, base)]
        when :delete
          [:delete, '/customers/:id', { 'id' => id, 'deleted' => true }]
        when :all
          [:get, '/customers', fake_list('/customers', lambda { customer_from({}, overrides) })]
        end
      when :recursion, :recursions
        case action.to_sym
        when :create
          [:post, '/recursions', recursion_from(params, overrides)]
        when :retrieve
          [:get, '/recursions/:id', recursion_from({}, { id: id }.merge(overrides))]
        when :resume
          [:post, '/recursions/:id/resume', recursion_from({}, { id: id, status: 'active' }.merge(overrides), base)]
        when :delete
          [:delete, '/recursions/:id', { 'id' => id, 'deleted' => true }]
        when :all
          [:get, '/recursions', fake_list('/recursions', lambda { recursion_from({}, overrides) })]
        end
      when :token, :tokens
        case action.to_sym
        when :create
          [:post, '/tokens', token_from(params, overrides)]
        when :retrieve
          [:get, '/tokens/:id', token_from({}, { 'id' => id }.merge(overrides))]
        end
      when :event, :events
        case action.to_sym
        when :retrieve
          [:get, '/events/:id', fake_event({ 'id' => id }.merge(overrides))]
        when :all
          [:get, '/events', fake_list('/events', lambda { fake_event(overrides) })]
        end
      when :account
        case action.to_sym
        when :retrieve
          [:get, '/account', fake_account(overrides)]
        when :delete_data
          [:delete, '/account/data', { deleted: true }]
        end
      end

    if path.include?(':id')
      if id.nil? || id == ''
        raise ArgumentError.new(":id in parameters is required")
      end
      path = path.gsub(':id', id)
    end

    spec =
      case options[:error]
      when :bad_request
        bad_request
      when :unauthorized
        unauthorized
      when :card_error
        card_error
      when :not_found
        not_found
      when :internal_server_error
        internal_server_error
      else # success
        { body: response.to_json }
      end

    stub_request(method, base_url + path).with(params).to_return(spec)

    JSON.parse(spec[:body])
  end
end
