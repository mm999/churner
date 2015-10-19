class Card < ActiveRecord::Base
	belongs_to :user
	after_create :anniversary_notice
end
