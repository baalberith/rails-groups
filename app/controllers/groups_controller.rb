class GroupsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :authenticate_admin!, :only => [:invite]
  
  def index
    @groups = Group.all
  end
  
  def show
    @group = Group.find(params[:id])
    @users = @group.users
    
    @invitation = MembershipInvitation.new
    @uninvited_users = User.all.find_all {|u| not @group.invited?(u) and not @group.member?(u)}
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.create(params[:group])

    if @group.save
      @membership = @group.memberships.create(:user_id => current_user.id, :admin => true)
      
      if @membership.save
        redirect_to groups_path
      else
         @group.delete
         render :new
      end
    else
      render :new
    end
  end
  
  def invite
    @group = Group.find(params[:id])
    @invitation = MembershipInvitation.new(params[:membership_invitation])
    @invitation.update_attributes(:group_id => @group.id)

    if @invitation.save
      redirect_to @group
    else
      render :show
    end
  end
  
  def authenticate_admin!
    @group = Group.find(params[:id])
    unless @group.admin?(current_user)
      redirect_to groups_path
    end
  end
end
