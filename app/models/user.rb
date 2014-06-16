class User < ActiveRecord::Base
  include BCrypt
  has_many :interests
  has_many :tags, through: :interests

  validates :name, presence: true
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\w+\@\w+\.\w*/, message: "only allows valid emails" }


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
