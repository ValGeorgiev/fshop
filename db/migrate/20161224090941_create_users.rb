class CreateUsers < ActiveRecord::Migration[5.0]
  def change
  	create_table :users do |u|
  		u.string :email
  		u.string :name
  		u.string :password
  		u.string :password_salt
  		u.string :role
		end
  end
end
