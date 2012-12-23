class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  attr_accessible :username, :email, :role, :password, :password_confirmation, :remember_me

  validates :username,              presence: true,
                                    uniqueness: true,
                                    length: { minimum: 4 }
  validates :email,                 presence: true,
                                    uniqueness: true
  validates :password,              presence: true,
                                    confirmation: true
  validates :password_confirmation, presence: true
  validates :role,                  inclusion: { :in => %w(manager visitor),
                                      :message => "%{value} is not a valid role"
                                    },
                                    allow_nil: true
end
