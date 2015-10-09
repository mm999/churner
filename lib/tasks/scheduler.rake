task :send_anniversary => :environment do

	time = Time.new
	month_in_seconds = 2592000
  Card.all.each do |card|
  	if card.issue_date.yday == (time + month_in_seconds).yday
  		user = User.where(:customer_id => card.customer_id).take
  		email = user.email
  		cardName = card.name
  		annualFee = "$"+card.annual_fee.round.to_s
  		anniversaryDate = card.issue_date.strftime("%B %e, %Y")
  		ChurnerMailer.anniversary(email, cardName, annualFee, anniversaryDate).deliver
  	end
  end
end