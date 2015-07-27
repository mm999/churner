class SubscriptionsController < ApplicationController
	before_action :authenticate_user!

	def new
	end

	def subscribe
		sub = Braintree::Subscription.create(
			:payment_method_token => params[:card_token],
			:plan_id => 'nfkg'
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
