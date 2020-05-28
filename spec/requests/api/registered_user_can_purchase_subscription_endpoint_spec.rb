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

  it 'responds with success message' do
    expect(response_json['message']).to eq 'Transaction was successful'
  end
end
