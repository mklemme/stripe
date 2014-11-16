class ChargesController < ApplicationController
  after_action :send_payment_general, only: [:create]

  def new
    @user = current_user
  end

  def create
    @user = current_user
    @trainer = Trainer.find_by_id(1)

    @amount = payment_params["charge_amount"].to_i / 100
    last_4_digits = payment_params["last_4"]
    amount = payment_params["charge_amount"]

    Stripe.api_key = Figaro.env.stripe_api_key



    # Get the credit card details submitted by the form
    if @user.stripe_id?
      token = @user.stripe_id
      customer = Stripe::Customer.retrieve(current_user.stripe_id)
      customer.email = current_user.email
      customer.save

      begin
        charge = Stripe::Charge.create(
          :amount => amount, # amount in cents, again
          :currency => "usd",
          :customer => token,
          :description => @user.email
        )

        rescue Stripe::CardError => e
          flash[:error] = e.message
          redirect_to event_path(@event)

      end
      redirect_to root_path, notice: "Your card was charged for #{@amount}"

    # If customer hasn't been created
    else

      token = params[:stripe_token]

      customer = Stripe::Customer.create(
        :email => current_user.email,
        :card => stripe_token,
        :description => current_user.email
      )

      charge = Stripe::Charge.create(
        :amount => amount, # amount in cents, again
        :currency => "usd",
        :card => token,
        :description => current_user.email
      )

      current_user.stripe_id = customer.id
      current_user.last_4_digits = last_4_digits
      current_user.save
      redirect_to root_path, notice: "Your Stripe account was create. Plus, we saved and charged your new card!"
    end




    # charge_amount = view_context.number_with_precision(params[:charge_amount], :precision => 2) * 100
    # Create the charge on Stripe's servers - this will charge the user's card

  end

  private

  def payment_params
    params.require(:user).permit(:stripe_token, :last_4, :charge_amount)
  end

  def send_payment_general
    UserMailer.payment_general(@user.id, @amount).deliver
  end
end
