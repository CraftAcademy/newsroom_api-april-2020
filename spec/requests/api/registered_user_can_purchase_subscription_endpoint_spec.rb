# frozen_string_literal: true

require 'stripe_mock'

describe 'POST /api/subscriptions', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:valid_token) { stripe_helper.generate_card_token }
  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }
  let!(:product) { stripe_helper.create_product }
  let!(:plan) do
    stripe_helper.create_plan(
      id: 'dns_subscription',
      amount: 50000,
      currency: 'usd',
      inteval: 'month',
      interval_count: 6,
      name: 'DNS Subscription 2',
      product: product.id
    )
  end



  describe 'with valid paramaters' do
    before do
      post '/api/subscriptions',
           params: {
             stripeToken: valid_token
           },
           headers: headers
    end

    it 'set the "subscriber" attribute to true on successfull transaction' do
      user.reload
      expect(user.subscriber).to eq true
    end

    it 'returns a success http code' do
      expect(response).to have_http_status 200
    end

    it 'returns a success message' do
      expect(response_json['message']).to eq 'Transaction was successful'
    end
  end


  describe 'with invalid parameters' do
    before do
      post '/api/subscriptions',
           headers: headers
    end

    it 'returns a error http code' do
      expect(response).to have_http_status 422
    end

    it 'does NOT set the "subscriber" attribute to true' do
      user.reload
      expect(user.subscriber).not_to eq true
    end

    it 'returns an error message' do
      expect(response_json['message']).to eq 'Transaction was NOT successful. There was no token provided...'
    end

  end
end
