
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  require 'stripe'
  def new
    @project = Project.find(params[:project])
  end

  def create
    @project = Project.find(params[:project])
    key = @project.user.access_code
    Stripe.api_key = key

    plan_id = params[:plan]
    plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]
    def self.execute(order:, user:)
    customer =  self.find_or_create_customer(card_token: order.token,
                                                 customer_id: user.stripe_customer_id,
                                                 email: user.email)
        if customer and user.update(stripe_customer_id: customer.id)
          order.customer_id = customer.id
          charge = self.execute_subscription(plan: product.stripe_plan_name,
                                             customer: customer)
        end
      end
      unless charge&.id.blank?
        # If there is a charge with id, set order paid.
        order.charge_id = charge.id
        order.set_paid
      end
    rescue Stripe::StripeError => e
      # If a Stripe error is raised from the API,
      # set status failed and an error message
      order.error_message = INVALID_STRIPE_OPERATION
      order.set_failed
    end

    stripe_acccount: key


    options = {
      stripe_id: customer.id,
      subscribed: true,
    }

    options.merge!(
      card_last4: params[:user][:card_last4],
      card_exp_month: params[:user][:card_exp_month],
      card_exp_year: params[:user][:card_exp_year],
      card_type: params[:user][:card_brand]
    )

    current_user.perk_subscriptions << plan_id
    current_user.update(options)

    # Update project attributes
    project_updates = {
      backings_count: @project.backings_count.next,
      current_donation_amount: @project.current_donation_amount + (plan.amount/100).to_i,
    }
    @project.update(project_updates)


    redirect_to root_path, notice: "Your subscription was setup successfully!"
  end

  def destroy
    subscription_to_remove = params[:id]
    plan_to_remove = params[:plan_id]
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.subscriptions.retrieve(subscription_to_remove).delete
    current_user.subscribed = false
    current_user.perk_subscriptions.delete(plan_to_remove)
    current_user.save
    redirect_to root_path, notice: "Your subscription has been cancelled."
  end
  private

  def self.execute_subscription(plan:, customer:)
    customer.subscriptions.create({
      plan: plan
    })
  end
  email = user.email
  def self.find_or_create_customer(card_token:, customer_id:, email:)
    if customer_id
      stripe_customer = Stripe::Customer.retrieve({ id: customer_id })
      if stripe_customer
        stripe_customer = Stripe::Customer.update(stripe_customer.id, { source: card_token})
      end
    else
      stripe_customer = Stripe::Customer.create({
        email: email,
        source: card_token
      })
    end
    stripe_customer
  end
