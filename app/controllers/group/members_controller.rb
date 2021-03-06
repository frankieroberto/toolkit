class Group::MembersController < ApplicationController
  before_filter :load_group
  filter_access_to :all, attribute_check: true, model: Group

  def index
    @committee = @group.committee_members.all
    @members = @group.normal_members.all
  end

  protected

  def load_group
    @group = Group.find(params[:group_id])
  end
end
