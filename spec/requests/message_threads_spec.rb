require "spec_helper"

describe "Message threads" do
  let(:thread) { FactoryGirl.create(:message_thread) }
  let(:threads) { FactoryGirl.create_list(:message_thread_with_messages, 5) }

  context "as a public user" do
    context "index" do
      before do
        threads
        visit threads_path
      end

      it "should list public message threads" do
        threads.each do |thread|
          page.should have_content(thread.title)
        end
      end

      it "should not show private message threads"
      it "should list threads by latest first"
    end

    context "show" do
      before do
        threads
        @thread = threads.first
        @messages = @thread.messages
        visit threads_path
        click_link @thread.title
      end

      it "should show the thread title" do
        within(".thread h1") do
          page.should have_content(@thread.title)
        end
      end

      it "should show messages on a public thread" do
        @messages.each do |message|
          page.should have_content(message.body)
        end
      end

      it "should show the authors of messages" do
        @messages.each do |message|
          within(dom_id_selector(message)) do
            page.should have_content(message.created_by.name)
          end
        end
      end

      it "should not allow access to a private thread"
    end
  end

  context "as a site user" do
    include_context "signed in as a site user"

    context "index" do
      before do
        threads
        visit threads_path
      end

      it "should list all public message threads" do
        threads.each do |thread|
          page.should have_content(thread.title)
        end
      end

      it "should list threads the user has created"
      it "should list all threads the user has been invited to"
    end

    context "show" do
      before do
        visit thread_path(thread)
      end

      it "should show all messages" do
        thread.messages.each do |message|
          page.should have_content(message.body)
        end
      end

      it "should be able to post a new message" do
        fill_in "Message", with: "Testing a new message!"
        click_on "Post Message"
        page.should have_content("Testing a new message!")
      end

      it "should show the number of subscribers" do
        page.should have_content("0 subscribers")
        click_on "Subscribe"
        page.should have_content("1 subscriber")
      end

      it "should show the names of subscribers" do
        click_on "Subscribe"
        within(".subscription-panel") do
          page.should have_content(current_user.name)
        end
      end
    end
  end


  context "as an admin user" do
    include_context "signed in as admin"

    context "index" do
      before do
        threads
        visit threads_path
      end

      it "should list all message threads"
    end
  end
end
