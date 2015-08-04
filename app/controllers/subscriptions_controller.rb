# This controller is not used anymore because I switched from
# optional subscription to a mandatory subscription whenver a
# user adds a card. The logic in subscribe was coppied into the
# create section of cards_controller and the unsubscribe is not
# needed because deleting a card automatically unsubscribes it
# from any subscription it is attached to. I will leave this
# code here for potential future use.

class SubscriptionsController < ApplicationController
	before_action :authenticate_user!

	def new
	end

	def subscribe
		sub = Braintree::Subscription.create(
			:payment_method_token => params[:card_token],
			:plan_id => 'churner-standard'
		)
		if sub.success?
			redirect_to cards_path
		else
			sub.errors.each do |error|
  			flash[:error] = error.message
			end
		redirect_to cards_path
		end
	end

	def unsubscribe
		sub = Braintree::Subscription.cancel(params[:subscription_id])
		if sub.success?
			redirect_to cards_path
		else
			sub.errors.each do |error|
  			flash[:error] = error.message
			end
			redirect_to cards_path
		end
	end

end
