class Settings < ActiveRecord::Base

  def self.update_stripe
    if User.current.stripe_id.nil?
      if !stripe_token.present?
        raise "We're doing something wrong -- this isn't supposed to happen"
      end

      customer = Stripe::Customer.create(
        :email => email,
        :description => stripe_description,
        :card => stripe_token
      )
      self.last_4_digits = customer.cards.data.first.last4
    else
      customer = Stripe::Customer.retrieve(stripe_id)

      if stripe_token.present?
        customer.card = stripe_token
      end

      # in case they've changed
      customer.email = email
      customer.description = stripe_description

      customer.save

      self.last_4_digits = customer.cards.data.first.last4
    end

    self.stripe_id = customer.id
    self.stripe_token = nil
  end

end
