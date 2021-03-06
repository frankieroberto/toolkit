class Group::MembershipsController < ApplicationController
  before_filter :load_group
  filter_access_to :all, attribute_check: true, model: Group

  def new
    @membership = @group.memberships.new
    @membership.build_user
  end

  def create
    @membership = @group.memberships.new(params[:group_membership])

    if @membership.save
      redirect_to group_members_path
    else
      render :new
    end
  end

  protected

  def load_group
    @group = Group.find(params[:group_id])
  end
end
