class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :name, :email, :password_hash
      t.timestamps
    end
  end
end
