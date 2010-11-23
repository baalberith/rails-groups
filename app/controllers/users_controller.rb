class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_current_user!, :only => [:invite]
  
  def index
    @users = User.all
  end
  
  def show
    @user        = User.find(params[:id])
    @groups      = @user.groups
      
    if  @user == current_user
      @invitations = @user.membership_invitations
    else
      @invitations = []
    end
      
    @membership  = Membership.new
  end
  
  def invite
    @user        = User.find(params[:id])
    @groups      = @user.groups
    
    @invitations = @user.membership_invitations
      
    inv = MembershipInvitation.find(params[:invitation])
    @membership = current_user.memberships.new(:group_id => inv.group_id)
    
    inv.delete
    @membership.save if params[:membership][:accept] == "1"
    
    render :show
  end
  
  def authenticate_current_user!
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_path
    end
  end
end
