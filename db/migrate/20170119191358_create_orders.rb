class CreateOrders < ActiveRecord::Migration[5.0]
  def change
  	create_table :orders do |o|
      o.integer :price
      o.string :city
      o.string :address
      o.string :status
  		o.belongs_to :user, index: true
      o.timestamps
		end
  end
end
