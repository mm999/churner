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

	  card = Braintree::PaymentMethod.create(
		  	:customer_id => customer.id,
		  	:payment_method_nonce => params[:payment_method_nonce] )

	  if card.success?
	  	@new_card = Card.new(
	  		:name => params[:card_name],
	  		:card_token => card.payment_method.token,
	  		:issue_date => params[:issue_date],
	  		:annual_fee => params[:annual_fee],
	  		:credit_limit => params[:credit_limit],
	  		:bank_name => params[:bank_name],
	  		:customer_id => customer.id )
	  	if @new_card.save
				redirect_to cards_path
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

	# def edit
	# 	if Card.find(params[:id]).customer_id == current_user.customer_id
	# 		@card = Card.find(params[:id])
	# 		@bt_card = Braintree::PaymentMethod.find(@card.card_token)
	# 	else
	# 		flash[:error] = "Card does not exi"
	# 		redirect_to cards_path
	# 	end
	# end

	# def update
	# 	bt_card = Braintree::PaymentMethod.update(
	# 		params[:card_token],
	# 		:payment_method_nonce => params[:payment_method_nonce] )
	# 	if bt_card.success?
	# 		card = Card.find(params[:id])
	# 		card.name = params[:card_name]
	# 		card.bank_name = params[:bank_name]
	# 		card.issue_date = params[:issue_date]
	# 		card.annual_fee = params[:annual_fee]
	# 		card.issue_date = params[:issue_date]
	# 		redirect_to card_path
	# 	else
	# 		card.errors.each do |error|
	# 			flash[:error] = error.message
	# 		end
	# 		redirect_to edit_card_path
	# 	end
	# end

	def delete
		Braintree::PaymentMethod.delete(params[:card_token])
		Card.destroy(params[:card_id])
		redirect_to cards_path
	end

	private

  def add_card_params
    params.require(:payment_method_nonce, :card_name).permit(:bank_name, :issue_date, :annual_fee, :credit_limit)
  end

end
