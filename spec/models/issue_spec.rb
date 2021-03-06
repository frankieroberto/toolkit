# == Schema Information
#
# Table name: issues
#
#  id            :integer         not null, primary key
#  created_by_id :integer         not null
#  title         :string(255)     not null
#  description   :text            not null
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  deleted_at    :datetime
#  category_id   :integer
#  location      :spatial({:srid=
#

require 'spec_helper'

describe Issue do
  describe "newly created" do
    subject { FactoryGirl.create(:issue) }

    it "must have a created_by user" do
      subject.created_by.should be_valid
    end

    it "should have an centre x" do
      subject.centre.x.should be_a(Float)
    end

    it "should have longitudes for x" do
      subject.centre.x.should < 181
      subject.centre.x.should > -181
    end

    it "should have latitudes for y" do
      subject.centre.y.should < 90
      subject.centre.y.should > -90
    end

    it "should have a geojson string" do
      subject.loc_json.should be_a(String)
      subject.loc_json.should eql(RGeo::GeoJSON.encode(subject.location).to_json)
    end
  end

  describe "to be valid" do
    subject { FactoryGirl.create(:issue) }

    it "must have a title" do
      subject.title = ""
      subject.should_not be_valid
    end

    it "must have a created_by user" do
      subject.created_by = nil
      subject.should_not be_valid
    end

    it "must have a description" do
      subject.description = nil
      subject.should_not be_valid
    end

    it "must have a location" do
      subject.location = nil
      subject.should_not be_valid
    end

    it "must return an empty geojson string when no location" do
      subject.location = nil
      subject.loc_json.should be_a(String)
      subject.loc_json.should eq("")
    end

    it "should accept a valid geojson string" do
      subject.location = nil
      subject.should_not be_valid
      subject.loc_json = '{"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0.14,52.27]}}'
      subject.should be_valid
      subject.location.x.should eql(0.14)
      subject.location.y.should eql(52.27)
    end

    it "should ignore a bogus geojson string" do
      subject.loc_json = 'Garbage'
      subject.should be_valid
    end
  end

  describe "threads" do
    context "new thread" do
      subject { FactoryGirl.create(:issue) }

      it "should set the title to be the same as the issue" do
        thread = subject.threads.build
        thread.title.should == subject.title
      end

      it "should set the privacy to public by default" do
        thread = subject.threads.build
        thread.should be_public
      end
    end
  end
end
