require "rails_helper"

feature "User manages their events" do
  scenario "asks visitors to sign in first" do
    visit new_event_path

    expect(current_path).to eq sign_in_path
  end

  scenario "User creates a new event" do
    visit new_event_path(as: create(:user))

    fill_in :event_name, with: "BarCamp"
    click_button "Create Event"

    expect(page).to have_content "Event was created!"
  end

  scenario "User edits an existing event" do
    user = create(:user)
    create(:event, name: "RubyConf", user: user)

    visit events_path(as: user)

    within find("tr", text: "RubyConf") do
      click_link "Edit"
    end

    fill_in :event_name, with: "RubyConf 2015"
    click_button "Update Event"

    expect(page).to have_content "Event was updated!"
  end
end
