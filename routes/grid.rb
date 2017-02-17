get '/products' do
	@products = Product.all

	erb :"products/productgrid"
end


get '/products/:query' do

	@_products = Product.all
	@products = []

	@_products.map do |product|

		@products.push(product) if product.category.include? params[:query]

	end

	erb :"products/productgrid"
end
