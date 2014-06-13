class Tag < ActiveRecord::Base
  has_many :users, through: :interests

end
