class User < ActiveRecord::Base
  include BCrypt

  #validates

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def self.create(params)
    @user = User.new(params[:user])
    @user.password = params[:user][:password]
    @user.save!
  end
end
