class Userproduct < ActiveRecord::Base
#	validates :email, presence: true, length: {minimum: 6, maximum: 120}
	belongs_to :user
	belongs_to :product
	belongs_to :order
end
