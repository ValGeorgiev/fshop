require 'json'

post '/product/add' do
	content_type :json

	pid = params[:pid]
	quantity = Integer(params[:quantity])
	size = params[:size]

	data = {}

	@product = Product.find_by_id(pid)
	not_complete = "NOT_COMPLETE"
	@currentproduct = Userproduct.where("status LIKE ? AND product_id LIKE ? AND user_id LIKE ?", "%#{not_complete}%", "%#{pid}%", "%#{session[:uid]}").first

	if @currentproduct && @currentproduct[:size] == size
		@currentproduct.quantity += quantity
		@currentproduct.save!
		data = {
			product: @uproduct.to_json,
			message: "Your product was added successfully! <br/> Go to basket"
		}
	elsif @product && @user

		@uproduct = Userproduct.create(
				product: @product,
				user: @user,
				quantity: quantity,
				size: size,
				status: "NOT_COMPLETE"
		)
		data = {
			product: @uproduct.to_json,
			message: "Your product was added successfully! <br/> Go to basket"
		}
	else
		data =	{
			error: true,
			message: "Sorry, we haven't found your basket!"
		}
	end
	data.to_json
end

get '/get/basket/size' do

	if session[:uid]
		content_type :json

		size = 0
		not_complete = "NOT_COMPLETE"

		@uproducts = Userproduct.where("status LIKE ? AND user_id LIKE ?", "%#{not_complete}%", "%#{session[:uid]}%")

		@uproducts.map do |uproduct|
			size += uproduct.quantity if uproduct.quantity
		end

		size.to_json
	else
		redirect '/'
	end

end
