class User < ActiveRecord::Base
#	validates :email, presence: true, length: {minimum: 6, maximum: 120}
	has_many :userproducts
	has_many :products, through: :userproducts
	has_one :user
end
