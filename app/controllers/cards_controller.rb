class CardsController < ApplicationController
	before_action :authenticate_user!

	def new
		@client_token = Braintree::ClientToken.generate
		@new_card = Card.new
	end

	def index
		@customer = Braintree::Customer.find(current_user.customer_id)
		@cards = @customer.credit_cards
		@total_cards = @cards.length
	end

	def create
	  customer = Braintree::Customer.find(current_user.customer_id)

	  card = Braintree::PaymentMethod.create(
		  	:customer_id => customer.id,
		  	:payment_method_nonce => params[:payment_method_nonce] )

	  if card.success?
	  	@new_card = Card.new(:name => params[:card_name], :card_token => card.payment_method.token)
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

	def delete
		Braintree::PaymentMethod.delete(params[:card_token])
		redirect_to cards_path
	end

	private

  def add_card_params
    params.require(:payment_method_nonce, :card_name)
  end

end
