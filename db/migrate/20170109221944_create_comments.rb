class CreateComments < ActiveRecord::Migration[5.0]
  def change
  	create_table :comments do |p|
  		p.string :pid
  		p.string :uname
  		p.text :comment
		end
  end
end
