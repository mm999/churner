class CardsController < ApplicationController
	before_action :authenticate_user!

	def index
		@customer = Braintree::Customer.find(current_user.customer_id)
		@cards = @customer.credit_cards
		@total_cards = @cards.length
	end

	def show
		if Card.find(params[:id]).customer_id == current_user.customer_id
			@card = Card.find(params[:id])
			@bt_card = Braintree::PaymentMethod.find(@card.card_token)

			# Check if current card has an active subscription
			@active_sub = false
			if @bt_card.subscriptions.last && @bt_card.subscriptions.last.status != 'Canceled'
				@active_sub = true
			end

			# Count the number of active subscriptions
			cards = Braintree::Customer.find(current_user.customer_id).credit_cards
			subscriptions = 0
			cards.each do |card|
				if card.subscriptions.last && card.subscriptions.last.status != 'Canceled'
					subscriptions += 1
				end
			end

			# User can have max two unsubscribed cards at once
			@can_unsub = false
			if cards.length - subscriptions < 2 && @active_sub
				@can_unsub = true
			end

		else
			flash[:error] = "Card does not exist"
			redirect_to cards_path
		end
	end

	def new
		@client_token = Braintree::ClientToken.generate
		@new_card = Card.new
	end

	def create
	  customer = Braintree::Customer.find(current_user.customer_id)

	  num_cards = Card.where(:customer_id => current_user.customer_id).length

	  card = Braintree::PaymentMethod.create(
		  	:customer_id => customer.id,
		  	:payment_method_nonce => params[:payment_method_nonce] )

	  if card.success?
	  	@new_card = Card.new(
	  		:customer_id  => customer.id,
	  		:card_token   => card.payment_method.token,
	  		:name         => params[:name],
	  		:issue_date   => params[:issue_date],
	  		:annual_fee   => params[:annual_fee],
	  		:credit_limit => params[:credit_limit],
	  		:note => params[:note])
	  	if num_cards >= 2
		  	if @new_card.save
					sub = Braintree::Subscription.create(
						:payment_method_token => card.payment_method.token,
						:plan_id              => 'churner-standard'
					)
					if sub.success?
						redirect_to cards_path
					else
						sub.errors.each do |error|
			  			flash[:error] = error.message
						end
					redirect_to cards_path
					end
				else
					redirect_to new_card_path
				end
			elsif num_cards < 2
				if @new_card.save
					redirect_to cards_path
				else
					redirect_to new_card_path
				end
			else
				redirect_to new_card_path
			end
		else
			card.errors.each do |error|
  			flash[:error] = error.message
			end
			redirect_to new_card_path
		end
	end

	def edit
		if Card.find(params[:id]).customer_id == current_user.customer_id
			@card = Card.find(params[:id])
			@bt_card = Braintree::PaymentMethod.find(@card.card_token)
			@client_token = Braintree::ClientToken.generate
		else
			flash[:error] = "Card does not exist"
			redirect_to cards_path
		end
	end

	def update
		if params[:card_token] != nil
			bt_card = Braintree::PaymentMethod.update(
				params[:card_token],
				:payment_method_nonce => params[:payment_method_nonce] )
			if bt_card.success?
				redirect_to card_path
			else
				bt_card.errors.each do |error|
					flash[:error] = error.message
				end
				redirect_to edit_card_path
			end
		else
			card = Card.find(params[:id])
			params[:name]         != "" ? card.name         = params[:name]         : nil
			params[:issue_date]   != "" ? card.issue_date   = params[:issue_date]   : nil
			params[:annual_fee]   != "" ? card.annual_fee   = params[:annual_fee]   : nil
			params[:credit_limit] != "" ? card.credit_limit = params[:credit_limit] : nil
			params[:note]         != "" ? card.note         = params[:note]         : nil
			if card.save
				redirect_to card_path
			else
				flash[:error] = "Card Data Not Updated"
				redirect_to card_path
			end
		end
	end

	def destroy
		if Braintree::PaymentMethod.delete(Card.find(params[:id]).card_token)
			deleted_card = Card.destroy(params[:id])
			if deleted_card.destroyed?
				redirect_to cards_path
			else
				flash[:error] = "Card Not Deleted"
			end
		else
			flash[:error] = "Card Not Deleted"
		end
	end

	private

  def card_params
    params.require(:payment_method_nonce).permit(:name, :issue_date, :annual_fee, :credit_limit)
  end

end
