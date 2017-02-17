require 'bcrypt'
require 'json'

before do
	@user = User.find_by_id(session[:uid])
end


get '/' do

	if @user && @user.role == "admin"
		redirect "/admin"
	else
		@products = Product.limit(5).order(popularity: :desc)

		if params[:no_auth]
			@error = "You should log in first!"
		end

		erb :"home/home"
	end
end

get '/cart' do
	if @user
	  @price = 0
		not_complete = "NOT_COMPLETE"

		@uproducts = Userproduct.where("status LIKE ? AND user_id LIKE ?", "%#{not_complete}%", "%#{session[:uid]}%")

		@uproducts.map do |uproduct|
			uproduct.quantity.times  do |i|
				@price += uproduct.product.price.gsub(/[^\d\.]/, '').to_f
			end if uproduct.quantity
		end

		erb :cart
  else
      halt 401, "Unauthorized"
  end
end


post '/signup' do
	salt = BCrypt::Engine.generate_salt
	hash_password = BCrypt::Engine.hash_secret(params[:password], salt)

	if (/^([0-9a-zA-Z]([-_\\.]*[0-9a-zA-Z]+)*)@([0-9a-zA-Z]([-_\\.]*[0-9a-zA-Z]+)*)[\\.]([a-zA-Z]{2,9})$/.match(params[:email]))
		@user = User.create(
			email: params[:email],
			password: hash_password,
			password_salt: salt,
			name: params[:name],
			role: "user"
		)

		session[:uemail] = @user.email
		session[:uid] = @user.id

		redirect "/"
	end
end

get '/logout' do
	session.clear

	redirect "/"
end

post '/login' do
  @user = User.find_by_email(params[:email])

  if !!@user

	  if @user.password == BCrypt::Engine.hash_secret(params[:password], @user.password_salt)
		  session[:uemail] = @user.email
			session[:uid] = @user.id
			redirect "/"
	  else
	  	@error = "Wrong credentials!"
	  	@user = nil
	  	erb :"home/home"
	  end


	else
		@error = "Wrong credentials!"
		erb :"home/home"
	end
end

post '/add/comment' do
	content_type :json

	if @user
		name = @user.name
	else
		name = "Anonymnous"
	end

	@comment = Comment.create(
			pid: params[:pid],
			uname: name,
			comment: params[:comment]
		)

	@comment.to_json

end

post '/get/comments' do
	content_type :json

	@comments = Comment.where("pid LIKE :pid", pid: "%#{params[:pid]}%")

	@comments.to_json
end

get '/orders' do
	if @user
		@orders = Order.where("user_id LIKE :user_id", user_id: "%#{session[:uid]}%")

		erb :"checkout/orders"
	else
		redirect '/?no_auth=true'
	end
end

# get '/createproducts' do

# 	Product.create(
# 		name: "Barcelona T-shirt",
# 		description: "Original FC Barcelona T-shirt",
# 		category: "t-shirt, barcelona, nike, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 500,
# 		image: '../img/sports/barcelona_tshirt.jpg',
# 		price: '$45.00'
# 	)


# 	Product.create(
# 		name: "Tiempo Mystic",
# 		description: "Nike Tiempo Mystic Astro Turf Trainers Mens",
# 		category: "footwear, astro, nike",
# 		size: '40,41,42,43,45,46,47',
# 		popularity: 215,
# 		image: '../img/sports/nike_astro_1.jpg',
# 		price: '$40.00'
# 	)
# 	Product.create(
# 		name: "Ace 17.3 Primemesh",
# 		description: "Adidas Ace 17.3 Primemesh Astro Turf Trainers Mens",
# 		category: "footwear, astro, adidas",
# 		size: '40,41,42,43,45,46,47',
# 		popularity: 220,
# 		image: '../img/sports/adidas_astro_1.jpg',
# 		price: '$46.00'
# 	)
# 	Product.create(
# 		name: "Goletto TF",
# 		description: "Adidas Goletto TF Football Boots Mens",
# 		category: "footwear, astro, adidas",
# 		size: '40,41,42,43,45,46,47',
# 		popularity: 200,
# 		image: '../img/sports/adidas_astro_2.jpg',
# 		price: '$42.00'
# 	)
# 	Product.create(
# 		name: "Mercurial Victory VI",
# 		description: "Nike Mercurial Victory VI Astro Turf Trainers Mens",
# 		category: "footwear, astro, nike",
# 		size: '40,41,42,43,45,46,47',
# 		popularity: 300,
# 		image: '../img/sports/nike_astro_2.jpg',
# 		price: '$50.00'
# 	)
# 	Product.create(
# 		name: "Tiempo Rio",
# 		description: "Nike Tiempo Rio Mens TF Trainers",
# 		category: "footwear, astro, nike",
# 		size: '40,41,42,43,45,46,47',
# 		popularity: 300,
# 		image: '../img/sports/nike_astro_3.jpg',
# 		price: '$36.00'
# 	)
# 	Product.create(
# 		name: "Hypervenom Phade",
# 		description: "Nike Hypervenom Phade Mens TF Trainers",
# 		category: "footwear, astro, nike",
# 		size: '40,41,42,43,45,46,47',
# 		popularity: 300,
# 		image: '../img/sports/nike_astro_4.jpg',
# 		price: '$32.00'
# 	)
# 	Product.create(
# 		name: "Ace 17.3 Primemesh FG",
# 		description: "Adidas Ace 17.3 Primemesh FG Football Boots Mens",
# 		category: "footwear, fboots, nike",
# 		size: '40,41,42,43,45,46',
# 		popularity: 300,
# 		image: '../img/sports/adidas_boots_1.jpg',
# 		price: '$50.00'
# 	)
# 	Product.create(
# 		name: "Mercurial Victory CR",
# 		description: "Nike Mercurial Victory CR Mens FG Football Boots",
# 		category: "footwear, fboots, nike",
# 		size: '40,41,42,43,45,46',
# 		popularity: 340,
# 		image: '../img/sports/nike_boots_1.jpg',
# 		price: '$60.00'
# 	)



# 	Product.create(
# 		name: "Manchester City T-shirt",
# 		description: "Original FC Manchester City T-shirt",
# 		category: "t-shirt, mancity, nike, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 100,
# 		image: '../img/sports/mancity_tshirt.jpg',
# 		price: '$30.00'
# 	)
# 	Product.create(
# 		name: "Liverpool T-shirt",
# 		description: "Original FC Liverpool T-shirt",
# 		category: "t-shirt, liverpool, newbalance, clothes",
# 		size: 'XS,M,L,XL',
# 		popularity: 320,
# 		image: '../img/sports/liverpool_tshirt.jpg',
# 		price: '$41.00'
# 	)
# 	Product.create(
# 		name: "Borussia Dortmund T-shirt",
# 		description: "Original FC Borussia Dortmund T-shirt",
# 		category: "t-shirt, borussia, puma",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 280,
# 		image: '../img/sports/borussia_tshirt.jpg',
# 		price: '$38.00'
# 	)
# 	Product.create(
# 		name: "Nike T-shirt",
# 		description: "Original Nike T-shirt",
# 		category: "t-shirt, nike, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 480,
# 		image: '../img/sports/nike_tshirt.jpg',
# 		price: '$50.00'
# 	)
# 	Product.create(
# 		name: "PSG T-shirt",
# 		description: "Original Paris Saint-Germain F.C. T-shirt",
# 		category: "t-shirt, psg, nike, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 250,
# 		image: '../img/sports/psg_tshirt.jpg',
# 		price: '$38.00'
# 	)
# 	Product.create(
# 		name: "Juventus T-shirt",
# 		description: "Original FC Juventus T-shirt",
# 		category: "t-shirt, juventus, adidas, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 320,
# 		image: '../img/sports/juventus_tshirt.jpg',
# 		price: '$40.00'
# 	)
# 	Product.create(
# 		name: "Levski T-shirt",
# 		description: "Original FC Levski T-shirt",
# 		category: "t-shirt, levski, joma, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 50,
# 		image: '../img/sports/levksi_tshirt.jpg',
# 		price: '$20.00'
# 	)
# 	Product.create(
# 		name: "Ludogorets T-shirt",
# 		description: "Original PFC Ludogorets T-shirt",
# 		category: "t-shirt, ludogorets, macron, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 100,
# 		image: '../img/sports/ludogorets_tshirt.jpg',
# 		price: '$24.00'
# 	)
# 	Product.create(
# 		name: "CSKA T-shirt",
# 		description: "Original FC CSKA Sofia T-shirt",
# 		category: "t-shirt, cska, legea, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 40,
# 		image: '../img/sports/cska_tshirt.jpg',
# 		price: '$12.00'
# 	)
# 	Product.create(
# 		name: "Real Madrid T-shirt",
# 		description: "Original Real Madrid T-shirt",
# 		category: "t-shirt, realmadrid, adidas, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 499,
# 		image: '../img/sports/realmadrid_tshirt.jpg',
# 		price: '$40.00'
# 	)
# 	Product.create(
# 		name: "Manchester United T-shirt",
# 		description: "Original FC Manchester United T-shirt",
# 		category: "t-shirt, manunt, adidas, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 488,
# 		image: '../img/sports/manunt_tshirt.jpg',
# 		price: '$40.00'
# 	)
# 	Product.create(
# 		name: "FC Arsenal T-shirt",
# 		description: "Original FC Arsenal T-shirt",
# 		category: "t-shirt, arsenal, puma, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 490,
# 		image: '../img/sports/arsenal_tshirt.jpg',
# 		price: '$37.00'
# 	)
# 	Product.create(
# 		name: "Bayern Munich T-shirt",
# 		description: "Original Bayern Munich T-shirt",
# 		category: "t-shirt, bayernmunich, adidas, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 400,
# 		image: '../img/sports/bayernmunich_tshirt.jpg',
# 		price: '$35.00'
# 	)
# 	Product.create(
# 		name: "Adidas T-shirt",
# 		description: "Original & Termo Adidas T-shirt",
# 		category: "t-shirt, adidas, clothes",
# 		size: 'XS,S,M,L,XL',
# 		popularity: 500,
# 		image: '../img/sports/adidas_tshirt.jpg',
# 		price: '$40.00'
# 	)
# 	Product.create(
# 		name: "Barcelona Ball",
# 		description: "Original FC Barcelona Ball",
# 		category: "accessory, ball, nike",
# 		popularity: 100,
# 		image: '../img/sports/barcelona_ball.jpg',
# 		price: '$12.00'
# 	)
# 	Product.create(
# 		name: "Real Madrid Ball",
# 		description: "Original FC Real Madrid Ball",
# 		category: "accessory, ball, adidas",
# 		popularity: 100,
# 		image: '../img/sports/realmadrid_ball.jpg',
# 		price: '$11.00'
# 	)
# 	Product.create(
# 		name: "Arsenal Ball",
# 		description: "Original FC Arsenal Ball",
# 		category: "accessory, ball, puma",
# 		popularity: 100,
# 		image: '../img/sports/arsenal_ball.jpg',
# 		price: '$11.00'
# 	)
# 	Product.create(
# 		name: "Manchester United Ball",
# 		description: "Original FC Manchester United Ball",
# 		category: "accessory, ball, nike",
# 		popularity: 100,
# 		image: '../img/sports/manunt_ball.jpg',
# 		price: '$11.00'
# 	)
# 	Product.create(
# 		name: "Chelsea Ball",
# 		description: "Original FC Chelsea Ball",
# 		category: "accessory, ball, adidas",
# 		popularity: 100,
# 		image: '../img/sports/chelsea_ball.jpg',
# 		price: '$10.00'
# 	)
# 	Product.create(
# 		name: "Manchester City Ball",
# 		description: "Original FC Manchester City Ball",
# 		category: "accessory, ball, nike",
# 		popularity: 100,
# 		image: '../img/sports/mancity_ball.jpg',
# 		price: '$10.00'
# 	)
# end
