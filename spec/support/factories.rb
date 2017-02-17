require 'factory_girl'
require 'bcrypt'


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do

  factory :admin do
    email 'valentin.al.georgiev@gmail.com'
    name 'Valentin Georgiev'
    password '123456789'
    password_salt BCrypt::Engine.generate_salt
    role 'admin'
  end

  factory :user do
    email 'valentin.georgiev@gmail.com'
    name 'Valentin Georgiev User'
    password '123456789'
    password_salt BCrypt::Engine.generate_salt
    role 'user'
  end

  factory :product do
  	name 'Test t-shirt'
  	description 'This is a test product'
  	size 'XS,S,L'
  	category 'test, adidas, t-shirt'
  	popularity 120
  	image '../img/sports/barcelona_tshirt.jpg'
  	price '$20.00'
  end

  factory :order do
  	price 50
  	city 'Test'
  	address 'Test address'
  	status 'NOT_COMPLETE'
  end

	factory :comment do
		pid '1'
		uname 'Valentin Georgiev User'
		comment 'This is a test comment'
  end
end
