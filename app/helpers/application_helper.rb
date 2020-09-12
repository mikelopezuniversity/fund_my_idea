module ApplicationHelper
  def author_of(resource)
    user_signed_in? && resource.user_id == current_user.id
  end
  def admin?
    user_signed_in? && current_user.admin?
  end
  def stripe_url
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_I0TiZfkMrP7R0emIruXxuVxYHCrXrccE&scope=read_write"
  end
  def stripe_connect_button
    link_to stripe_url, class: "btn-stripe-connect" do
      content_tag :span, "Connect with Stripe"
    end
  end
end
