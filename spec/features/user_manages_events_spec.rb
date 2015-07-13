require "rails_helper"

feature "User manages their events" do
  scenario "asks visitors to sign in first" do
    visit signed_in_root_path

    expect(current_path).to eq root_path
    expect(page).to have_content(t("layouts.application.sign_in"))
  end

  scenario "and sees a list of their events" do
    create_user_and_events
    visit signed_in_root_path(as: @user)

    expect(page).to have_css("ul.events > li", count: 3)
  end

  scenario "and activates an event" do
    create_user_and_events

    expect(AttendeeFetcherJob).to receive(:perform_later).once

    visit signed_in_root_path(as: @user)

    within "ul.events > li[data-id='#{@events.first.id}']" do
      click_on "Activate"
    end

    within "ul.events > li[data-id='#{@events.first.id}']" do
      expect(page).to have_link("Deactivate")
    end
  end

  scenario "and deactivates an event" do
    create_user_and_events
    Event.first.update(active: true)

    visit signed_in_root_path(as: @user)

    within "ul.events > li[data-id='#{@events.first.id}']" do
      click_on "Deactivate"
    end

    within "ul.events > li[data-id='#{@events.first.id}']" do
      expect(page).to have_link("Activate")
    end
  end

  def create_user_and_events
    @user = create(:user, :eventbrite_authenticated)
    @events = create_list(:event, 3, user: @user)
  end
end
