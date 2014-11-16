class ChargesController < ApplicationController
  after_action :send_payment_general, only: [:create]

  def new
    @user = current_user
  end

  def create
    @user = current_user
    @trainer = Trainer.find_by_id(1)
    @amount = params[:charge_amount]
    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here https://dashboard.stripe.com/account

    Stripe.api_key = Figaro.env.stripe_api_key

    # Get the credit card details submitted by the form
    if @user.stripe_id?
      token = @user.stripe_id
    else
      token = params[:stripe_token]
    end

    charge_amount = (params[:charge_amount].to_d * 100).to_i


    # charge_amount = view_context.number_with_precision(params[:charge_amount], :precision => 2) * 100
    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        :amount => charge_amount, # amount in cents, again
        :currency => "usd",
        :customer => token,
        :description => @user.email
      )

      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to event_path(@event)
    end
    redirect_to root_path, notice: "OK"
  end

  private

  def send_payment_general
    UserMailer.payment_general(@user.id, @amount).deliver
  end
end
