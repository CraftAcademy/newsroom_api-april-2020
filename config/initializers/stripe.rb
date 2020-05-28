Stripe.plan :dns_subscription do |plan|
  plan.name = "DNS Subscription 2"
  plan.amount = 50000
  plan.currency = "sek"
  plan.interval = "month"
  plan.interval_count = 6
end