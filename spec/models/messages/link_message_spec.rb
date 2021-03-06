require 'spec_helper'

describe LinkMessage do
  describe "associations" do
    it { should belong_to(:thread) }
    it { should belong_to(:message) }
    it { should belong_to(:created_by) }
  end

  describe "validations" do
    it { should validate_presence_of(:url) }
  end

  context "URLs" do
    subject { LinkMessage.new }

    it "should allow a valid URL with HTTP protocol" do
      subject.url = "http://en.wikipedia.org/wiki/Family_Guy"
      subject.should have(0).errors_on(:url)
    end

    it "should allow a valid URL with HTTPS protocol" do
      subject.url = "https://en.wikipedia.org/wiki/Family_Guy"
      subject.should have(0).errors_on(:url)
    end

    it "should allow a valid URL without protocol" do
      subject.url = "en.wikipedia.org/wiki/Family_Guy"
      subject.should have(0).errors_on(:url)
    end

    it "should prefix the HTTP protocol on a URL without protocol" do
      subject.url = "en.wikipedia.org/wiki/Family_Guy"
      subject.url.should == "http://en.wikipedia.org/wiki/Family_Guy"
    end

    it "should not allow a URL with FTP protocol" do
      subject.url = "ftp://en.wikipedia.org/wiki/Family_Guy"
      subject.should have(1).error_on(:url)
    end

    it "should not allow an invalid URL" do
      subject.url = "w[iki]pedia.org/wiki/Family_Guy"
      subject.should have(1).error_on(:url)
    end
  end
end
