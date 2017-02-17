class CreateProducts < ActiveRecord::Migration[5.0]
  def change
  	create_table :products do |p|
  		p.string :name
  		p.text :description
  		p.string :size
  		p.string :category
  		p.integer :popularity
  		p.string :image
      p.string :price
		end
  end
end
