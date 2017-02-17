require 'json'

post '/admin/search' do
	if @user && @user.role == "admin"
		index = params[:index]

		if index == ''
			@products = Product.all
		else
			@_products = Product.all
			@products = []

			@_products.map do |product|
				@products.push(product) if product.category.include? index
			end
		end

		erb :"admin/productgrid"
	else
		halt 401, "Unauthorized"
	end
end

post '/admin/add/product' do
	if @user && @user.role == "admin"
		File.open('public/img/sports/' + params['image'][:filename], "wb") do |f|
	    f.write(params['image'][:tempfile].read)
	  end
	  img = "../img/sports/#{params['image'][:filename]}"

	  @product = Product.create(
			name: params[:name],
			description: params[:description],
			category: params[:category],
			size: params[:size],
			popularity: params[:popularity],
			image: img,
			price: params[:price]
		)

		session[:aid] = @product.id

		redirect '/admin/add'
	else
		halt 401, "Unauthorized"
	end
end

get '/admin/add' do
	if @user && @user.role == "admin"
		if session[:aid]
			@product = Product.find_by_id(session[:aid])
		end

		erb :"admin/addproduct"
	else
		halt 401, "Unauthorized"
	end
end

get '/admin/users' do
	if @user && @user.role == "admin"
		@users = User.all

		erb :"admin/users"
	else
		halt 401, "Unauthorized"
	end
end


get '/admin/logout' do
	session.clear
	redirect "/"
end


get '/admin' do
	if @user && @user.role == "admin"
		@products = {}
		erb :"admin/home"
	else
		halt 401, "Unauthorized"
	end

end


post '/admin/delete' do
	if @user && @user.role == "admin"
		@users = User.all

		@updated_user = User.find_by_id(params[:id])
		@updated_user.role = 'user'
		@updated_user.save
		erb :"admin/usergrid", :layout => false
	else
		halt 401, "Unauthorized"
	end
end

post '/admin/new' do
	if @user && @user.role == "admin"
		@users = User.all

		@updated_user = User.find_by_id(params[:id])
		@updated_user.role = 'admin'
		@updated_user.save
		erb :"admin/usergrid", :layout => false
	else
		halt 401, "Unauthorized"
	end
end

post '/admin/order/complete' do
	if @user && @user.role == "admin"
		@orders = Order.all

		@updated_order = Order.find_by_id(params[:id])
		@updated_order.status = 'COMPLETE'
		@updated_order.save
		erb :"admin/ordergrid", :layout => false
	else
		halt 401, "Unauthorized"
	end
end

post '/admin/order/notcomplete' do
	if @user && @user.role == "admin"
		@orders = Order.all

		@updated_order = Order.find_by_id(params[:id])
		@updated_order.status = 'NOT_COMPLETE'
		@updated_order.save
		erb :"admin/ordergrid", :layout => false
	else
		halt 401, "Unauthorized"
	end
end

delete '/admin/delete/product' do
	if @user && @user.role == "admin"
		@product = Product.find_by_id(params[:id])
		@product.destroy
	else
		halt 401, "Unauthorized"
	end
end

delete '/admin/delete/comment' do
	if @user && @user.role == "admin"
		@comment = Comment.find_by_id(params[:id])
		@comment.destroy
	else
		halt 401, "Unauthorized"
	end
end


post '/admin/get/product' do
	if @user && @user.role == "admin"
		content_type :json

		@product = Product.find_by_id(params[:id])

		@product.to_json
	else
		halt 401, "Unauthorized"
	end
end


post '/admin/edit/product' do
	if @user && @user.role == "admin"
	  @product = Product.find_by_id(params[:id])
		@products = Product.all

		if params[:image]
			File.open('public/img/sports/' + params[:image][:filename], "wb") do |f|
		    f.write(params[:image][:tempfile].read)
		  end
		  img = "../img/sports/#{params['image'][:filename]}"
			@product.image = img
		end

	  @product.name = params[:name]
		@product.description = params[:description]
		@product.size = params[:size]
		@product.popularity = params[:popularity]
		@product.price = params[:price]

		@product.save

		redirect '/'
	else
		halt 401, "Unauthorized"
	end

end

get '/admin/orders' do
	if @user && @user.role == "admin"
		@orders = Order.all

		erb :"admin/orders"
	else
		halt 401, "Unauthorized"
	end
end
