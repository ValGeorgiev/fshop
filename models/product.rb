class Product < ActiveRecord::Base
#	validates :email, presence: true, length: {minimum: 6, maximum: 120}

	has_many :userproducts
	has_many :users, through: :userproducts
end
