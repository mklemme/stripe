class UserController < ApplicationController


  def payment_info
    @user = current_user
    if !current_user
      redirect_to root_path
    else
      render "settings_payments"
    end
  end

  def payment_update

    @user = current_user
    Stripe.api_key = Figaro.env.stripe_api_key
    stripe_token  = payment_params["stripe_token"]
    last_4_digits = payment_params["last_4"]

    # current_user.update_attributes(payment_params)

    update_stripe(stripe_token, last_4_digits)

    if current_user.save

      redirect_to root_path, :notice => "Profile updated"
    end

    rescue Stripe::StripeError => e
      flash[:error] = e.message
      render "settings_payments"

    rescue Stripe::CardError => e
      flash[:error] = e.message
      render "settings_payments"

  end

  private

  def update_stripe(stripe_token, last_4_digits)

    Stripe.api_key = Figaro.env.stripe_api_key

    if current_user.stripe_id.nil?
      if !stripe_token.present?
        puts "We're doing something wrong -- this isn't supposed to happen"
      end

      customer = Stripe::Customer.create(
        :email => current_user.email,
        :card => stripe_token,
        :description => current_user.email
      )

      current_user.last_4_digits = last_4_digits
      p current_user
    else

      customer = Stripe::Customer.retrieve(current_user.stripe_id)
      customer.card = stripe_token

      # in case they've changed
      customer.email = current_user.email
      customer.save
      current_user.last_4_digits = customer.cards.data.first.last4
      current_user.save
      p current_user
      p customer
    end

    current_user.stripe_id = customer.id
    stripe_token = nil
    current_user.save
  end

  def payment_params
    params.require(:user).permit(:stripe_token, :last_4)
  end


end
