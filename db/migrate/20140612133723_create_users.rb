class CreateUsers < ActiveRecord::Migration
  def change
    create_table :user do |t|
      t.string :username, :name, :email. :password_has
      t.timestamps
    end
  end
end
