class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Let a user also be a trainer
  has_one :trainer

  attr_accessor :stripe_token, :last_4_digits

  def self.update_stripe(current_user, stripe_token)

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

      current_user.last_4_digits = customer.cards.data.first.last4

    else

      customer = Stripe::Customer.retrieve(current_user.stripe_id)
      customer.card = stripe_token

      # in case they've changed
      customer.email = current_user.email
      customer.save
      current_user.last_4_digits = customer.cards.data.first.last4

    end

    current_user.stripe_id = customer.id
    stripe_token = nil

    return current_user
  end
end
