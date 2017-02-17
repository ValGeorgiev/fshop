require 'json'

# Helper
def logged_in?
  !session[:uid].nil?
end

# Define the condition
set(:auth) do |*roles|
  condition do
    if !logged_in?

      redirect '/'
    else
      @user = User.find_by_id(session[:uid])
    end
  end
end

delete '/delete/cart', :auth => [:user, :admin] do
	if @user

		content_type :json
		@uproduct = Userproduct.find_by_id(params[:pid])
		@uproduct.destroy

		not_complete = "NOT_COMPLETE"
		@uproducts = Userproduct.where("status LIKE ? AND user_id LIKE ?", "%#{not_complete}%", "%#{session[:uid]}%")
	 	@price = 0
		@uproducts.map do |uproduct|
			uproduct.quantity.times  do |i|
				@price += uproduct.product.price.gsub(/[^\d\.]/, '').to_f
			end if uproduct.quantity
		end

		@price.to_json
	else
		halt 401, "Unauthorized"
	end

end

get '/checkout', :auth => [:user, :admin] do
	if @user
		not_complete = "NOT_COMPLETE"
		@uproducts = Userproduct.where("status LIKE ? AND user_id LIKE ?", "%#{not_complete}%", "%#{session[:uid]}%")
	 	@price = 0
		@uproducts.map do |uproduct|
			uproduct.quantity.times  do |i|
				@price += uproduct.product.price.gsub(/[^\d\.]/, '').to_f
			end if uproduct.quantity
		end

		erb :"checkout/checkout"
	else
		halt 401, "Unauthorized"
	end
end


post '/checkout/start', :auth => [:user, :admin] do

	if @user

		@order = Order.create(
			user: @user,
			price: Integer(params[:price].to_f.round),
			city: params[:city],
			address: params[:address],
			status: "NOT_COMPLETE"
		)

		not_complete = "NOT_COMPLETE"

		@uproducts = Userproduct.where("status LIKE ? AND user_id LIKE ?", "%#{not_complete}%", "%#{session[:uid]}%")

		@uproducts.each do |up|
			up.status = "COMPLETE"
			up.order = @order
			up.save!
		end

		erb :"checkout/thankyou"

	else
		halt 401, "Unauthorized"
	end

end
