class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :recoverable, :trackable, :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  has_many :memberships
  has_many :groups, :through => :memberships

  has_many :membership_invitations
end
