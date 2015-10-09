class Card < ActiveRecord::Base
	belongs_to :user
	after_create :anniversary_notice

	def anniversary_notice
		#send anniversary notice here
	end
end
