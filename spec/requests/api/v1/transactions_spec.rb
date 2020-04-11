require 'swagger_helper'

describe 'Authentication' do
  path '/auth'
end

describe 'Transactions' do

  path '/api/v1/transactions' do

    post 'Creates a transaction' do
      tags 'Transactions'
      consumes 'application/json', 'application/xml'
      parameter name: :client, in: :header, :type => :string
      parameter name: :'access-token', in: :header, :type => :string
      parameter name: :uid, in: :header, :type => :string
      parameter name: :transaction, in: :body, schema: {
          type: :object,
          properties: {
              symbol: { type: :string },
              description: { type: :string },
              value: { type: :number },
              amount: { type: :number }
          }
      }

      response '201', 'transaction created' do

        let(:auth_params) do
          user = FactoryBot.create(:user)
          get_auth_headers(user)
        end

        let(:client) { auth_params['client'] }
        let(:'access-token') { auth_params['access-token'] }
        let(:uid) { auth_params['uid'] }
        let(:transaction) { { symbol: 'S&P', value: 2222.0, amount: 0.5 } }
        run_test!
      end

      response '401', 'unauthorized request' do
        let(:client) {'bad'}
        let(:'access-token') {'bad'}
        let(:uid) {'bad'}
        let(:transaction) { { symbol: 'S&P' } }
        run_test!
      end
    end
  end

  path '/api/v1/transactions/{id}' do

    get 'Retrieves a transaction' do
      tags 'Transactions'
      produces 'application/json', 'application/xml'
      parameter name: 'client', in: :header, :type => :string
      parameter name: 'access-token', in: :header, :type => :string
      parameter name: 'uid', in: :header, :type => :string
      parameter name: :id, :in => :path, :type => :string

      response '200', 'transaction found' do
        schema type: :object,
               properties: {
                   id: { type: :string },
                   symbol: { type: :string },
                   description: { type: :string },
                   value: { type: :number },
                   amount: { type: :number },
                   created_at: { type: :string, format: :'date-time' },
                   updated_at: { type: :string, format: :'date-time' }
               }

        let(:auth_params) do
          user = FactoryBot.create(:user)
          get_auth_headers(user)
        end

        let(:transaction) do
          FactoryBot.create(:transaction)
        end

        let(:client) { auth_params['client'] }
        let(:'access-token') { auth_params['access-token'] }
        let(:uid) { auth_params['uid'] }
        let(:id) { transaction.id }
        run_test!
      end

      response '401', 'unauthorized request' do
        let(:auth_params) do
          user = FactoryBot.create(:user)
          get_auth_headers(user)
        end
        let(:client) { 'bad' }
        let(:'access-token') { 'bad' }
        let(:uid) { 'bad' }
        let(:id) { Transaction.create(symbol: 'S&P', value: 2222.0, amount: 0.5).id }
        run_test!
      end

      response '404', 'transaction not found' do
        let(:auth_params) do
          user = FactoryBot.create(:user)
          get_auth_headers(user)
        end

        let(:transaction) do
          FactoryBot.create(:transaction)
        end

        let(:client) { auth_params['client'] }
        let(:'access-token') { auth_params['access-token'] }
        let(:uid) { auth_params['uid'] }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end