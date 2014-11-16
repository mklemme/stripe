class ChargesController < ApplicationController
  def new
  end

  def create
    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here https://dashboard.stripe.com/account
    Stripe.api_key = Figaro.env.stripe_api_key

    # Get the credit card details submitted by the form
    token = params[:stripeToken]

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        :amount => 1000, # amount in cents, again
        :currency => "usd",
        :card => token,
        :description => "payinguser@example.com"
      )

      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to event_path(@event)
    end
    flash.now[:notice] = "OK"
    redirect_to root_path
  end
end
