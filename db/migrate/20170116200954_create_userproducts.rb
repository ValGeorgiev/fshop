class CreateUserproducts < ActiveRecord::Migration[5.0]
  def change
  	create_table :userproducts do |u|
      u.belongs_to :user, index: true
      u.belongs_to :product, index: true
      u.belongs_to :order, index: true
      u.string :size
      u.integer :quantity
      u.string :status
		end
  end
end
