class Order < ActiveRecord::Base
#	validates :email, presence: true, length: {minimum: 6, maximum: 120}
	has_many :userproducts
	has_many :products, through: :userproducts
	belongs_to :user
end
