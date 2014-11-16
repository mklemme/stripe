class TrainerController < ApplicationController


  def update
    @user = current_user
    @trainer = Trainer.find_by_id(1)
    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here https://dashboard.stripe.com/account

    Stripe.api_key = Figaro.env.stripe_api_key

    token_id = params[:stripeToken]

    begin
      recipient = Stripe::Recipient.create(
        :name => "John Doe",
        :type => "individual",
        :email => "payee@example.com",
        :card => token_id
      )
      rescue Stripe::CardError => e
        redirect_to settings_payments_path, error: e.message
    end
    redirect_to root_path, notice: "OK"
  end
end
