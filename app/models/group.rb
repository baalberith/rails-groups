class Group < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  
  has_many :membership_invitations, :dependent => :destroy
  
  def admins
    memberships.where(:admin => true).map(&:user)
  end
  
  def admin?(user)
    admins().include?(user)
  end
  
  def member?(user)
    users.include?(user)
  end
  
  def invited?(user)
    membership_invitations.map(&:user_id).include?(user.id)
  end
end
