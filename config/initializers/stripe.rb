
Rails.configuration.stripe = {
  :publishable_key => ENV['pk_test_Vwz7XW2mCMZr5vmoJmkU0heZ'],
  :secret_key      => ENV['sk_test_1BnOwo7U8yEOByrQo7AH3sGU']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
