# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  full_name              :string(255)     not null
#  display_name           :string(255)
#  role                   :string(255)     not null
#  encrypted_password     :string(128)     default("")
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  disabled_at            :datetime
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#

require 'spec_helper'

describe User do
  describe "newly created" do
    subject { FactoryGirl.create(:user) }

    it "must have a member role" do
      subject.role.should == "member"
    end

    it "should be active" do
      subject.disabled.should be_false
    end
  end

  describe "to be valid" do
    subject { FactoryGirl.build(:user) }

    it "must have a role" do
      subject.role = ""
      subject.should_not be_valid
    end

    it "role can be a member" do
      subject.role = "member"
      subject.should be_valid
    end

    it "role can be an admin" do
      subject.role = "admin"
      subject.should be_valid
    end

    it "role cannot be an oompah loompa" do
      subject.role = "oompah loompa"
      subject.should_not be_valid
    end

    it "must have a full name" do
      subject.full_name = ""
      subject.should have(1).error_on(:full_name)
    end

    it "must have a password" do
      subject.password = ""
      subject.should have_at_least(1).error_on(:password)
    end

    it "must have a password unless being invited" do
      subject.password = ""
      subject.invite!
      subject.should have(0).errors_on(:password)
    end
  end

  describe "with admin role" do
    it "should have the admin role" do
      admin = FactoryGirl.build(:stewie)
      admin.role.should == "admin"
    end
  end

  describe "name" do
    subject { FactoryGirl.build(:stewie) }

    it "should use the full name if no display name is set" do
      subject.display_name = ""
      subject.name.should == "Stewie Griffin"
    end

    it "should use the display name if set" do
      subject.display_name = "Stewie"
      subject.name.should == "Stewie"
    end
  end

  context "declarative authorization interface" do
    subject { FactoryGirl.build(:stewie) }

    it "should respond to role_symbols" do
      subject.role_symbols.should == [:admin]
    end
  end

  describe "profile association" do
    subject { FactoryGirl.build(:user) }

    it "should give a new blank profile if one doesn't already exist" do
      subject.profile.should be_a(UserProfile)
      subject.profile.should be_new_record
    end

    it "should give the actual user profile if one exists" do
      profile = FactoryGirl.create(:user_profile, user: subject)
      subject.profile.should == profile
    end
  end

  context "name with email" do
    subject { FactoryGirl.build(:user) }

    it "should give email in valid format using chosen name" do
      subject.name_with_email.should == "#{subject.name} <#{subject.email}>"
    end

    it "should use full name if display name is not set" do
      subject.display_name = nil
      subject.name_with_email.should == "#{subject.full_name} <#{subject.email}>"
    end
  end

  context "thread subscriptions" do
    subject { FactoryGirl.create(:user) }
    let(:thread) { FactoryGirl.create(:message_thread) }

    before do
      thread.subscribers << subject
    end

    it "should have one thread subscription" do
      subject.should have(1).thread_subscription
    end

    context "subscribed_to_thread?" do
      it "should return true if user is subscribed to the thread" do
        subject.subscribed_to_thread?(thread).should be_true
      end

      it "should return false if user is not subscribed" do
        new_thread = FactoryGirl.create(:message_thread)
        subject.subscribed_to_thread?(new_thread).should be_false
      end
    end
  end

  context "account disabling" do
    subject { FactoryGirl.create(:user) }

    it "should be disabled" do
      subject.disabled = "1"
      subject.disabled.should be_true
      subject.disabled_at.should be_a_kind_of(Time)
    end

    it "should be enabled" do
      subject.disabled = "1"
      subject.disabled = "0"
      subject.disabled.should be_false
      subject.disabled_at.should be_nil
    end
  end
end
