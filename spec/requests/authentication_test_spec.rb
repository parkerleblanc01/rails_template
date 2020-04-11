# spec/requests/authentication_test_spec.rb

require 'rails_helper'
include ActionController::RespondWith


# The authentication header looks something like this:
# {"access-token"=>"abcd1dMVlvW2BT67xIAS_A", "token-type"=>"Bearer", "client"=>"LSJEVZ7Pq6DX5LXvOWMq1w", "expiry"=>"1519086891", "uid"=>"darnell@konopelski.info"}

describe 'Whether access is occurring properly', type: :request do
  before(:each) do
    @current_user = FactoryBot.create(:user)
    @transaction = FactoryBot.create(:transaction)
  end

  context 'context: general authentication via API, ' do
    it "doesn't give you anything if you don't log in" do
      get api_v1_transaction_path(@transaction)
      expect(response.status).to eq(401)
    end

    it 'gives you an authentication code if you are an existing user and you satisfy the password' do
      login(@current_user)
      # puts "#{response.headers.inspect}"
      # puts "#{response.body.inspect}"
      expect(response.has_header?('access-token')).to eq(true)
    end

    it 'gives you a status 200 on signing in ' do
      login(@current_user)
      expect(response.status).to eq(200)
    end

    it 'first get a token, then access a restricted page' do
      auth_params = get_auth_headers(@current_user)
      transaction = FactoryBot.create(:transaction)
      status_code = get api_v1_transactions_path(transaction.id), headers: auth_params
      expect(status_code).to eq(200)
    end

    it 'denies access to a restricted page with an incorrect token' do
      login(@current_user)
      auth_params = get_auth_params_from_login_response_headers(response, false)

      transaction = FactoryBot.create(:transaction)
      # sleep(5)
      status_code = get api_v1_transaction_path(transaction.id), headers: auth_params
      expect(status_code).to eq(401)
    end
  end

  RSpec.shared_examples 'use authentication tokens of different ages' do |token_age, http_status|
    let(:vary_authentication_age) { token_age }

    it 'uses the given parameter' do
      expect(vary_authentication_age(token_age)).to eq(http_status)
    end

    def vary_authentication_age(token_age)
      auth_params = get_auth_headers(@current_user)
      transaction = FactoryBot.create(:transaction)
      status_code = get api_v1_transaction_path(transaction.id), headers: auth_params
      expect(status_code).to eq(200)

      allow(Time).to receive(:now).and_return(Time.now + token_age)

      get api_v1_transaction_path(transaction.id), headers: auth_params
    end
  end

  context 'test access tokens of varying ages' do
    include_examples 'use authentication tokens of different ages', 2.days, 200
    include_examples 'use authentication tokens of different ages', 5.years, 401
  end

end