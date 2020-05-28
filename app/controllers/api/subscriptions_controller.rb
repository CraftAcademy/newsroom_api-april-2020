# frozen_string_literal: true

class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  def create
    # check if there is a stripeToken in params
    # create a stripe customer based on the current_user and the stipeToken
    # assign a subscription plan to the newly created customer
    # update the current_user to a subscriber
    # respond with a success message
    if params[:stripeToken]
      current_user.update_attribute(:subscriber, true)
      render json: { message: 'Transaction was successful' }
    else
      render json: { message: 'Transaction was NOT successful. There was no token provided...' }, status: 422
    end
  end
end
