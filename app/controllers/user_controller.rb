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

    current_user.update_attributes(payment_params)

    User.update_stripe(current_user, stripe_token)

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

  def payment_params
    params.require(:user).permit(:stripe_token, :last_4_digits)
  end


end
