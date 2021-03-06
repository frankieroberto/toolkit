# == Schema Information
#
# Table name: group_memberships
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  group_id   :integer         not null
#  role       :string(255)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime
#

class GroupMembership < ActiveRecord::Base
  ALLOWED_ROLES = %w(committee member)

  belongs_to :group
  belongs_to :user, autosave: true

  scope :committee, where("role = 'committee'")
  scope :normal, where("role = 'member'")

  before_validation :replace_with_existing_user
  before_validation :invite_user_if_new

  validates :group_id, presence: true
  validates :role, inclusion: {in: ALLOWED_ROLES}
  validates_associated :user

  accepts_nested_attributes_for :user

  def self.allowed_roles_map
    ALLOWED_ROLES.map {|r| [r.capitalize, r] }
  end

  def role=(val)
    write_attribute(:role, val.downcase)
  end

  protected

  def replace_with_existing_user
    if user
      existing = User.find_by_email(user.email)
      self.user = existing if existing
    end
    true
  end

  def invite_user_if_new
    user && user.new_record? && user.invite!
    true
  end
end
