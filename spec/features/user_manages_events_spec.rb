require "rails_helper"

feature "User manages their events" do
  scenario "asks visitors to sign in first" do
    visit events_path

    expect(current_path).to eq sign_in_path
  end

  scenario "and sees a list of their events" do
    visit events_path(as: create(:user, :eventbrite_authenticated))

    expect(page).to have_css("table.events")
  end

  # scenario "User creates a new event" do
  #   visit events_path(as: create(:user))
  #   click_on "Add Event"

  #   fill_in :event_name, with: "BarCamp"
  #   click_on t('event.create')

  #   expect(page).to have_content "Event was created!"
  # end

  # scenario "User edits an existing event" do
  #   user = create(:user)
  #   event = create(:event, name: "RubyConf", user: user)

  #   visit events_path(as: user)
  #   edit_event(event)

  #   fill_in :event_name, with: "RubyConf 2015"
  #   click_on t('event.update')

  #   expect(page).to have_content "Event was updated!"
  # end

  # def edit_event(event)
  #   within find("tr[data-id='#{event.id}']") do
  #     click_link t('shared.edit')
  #   end
  # end
end
