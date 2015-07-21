describe "rails_helper"

feature "User enables kiosk mode" do
  scenario "and attendees can sign in" do
    create_user_and_event
    visit signed_in_root_path(as: @user)

    within "ul.events > li[data-id='#{@event.id}']" do
      click_link "Enable Kiosk Mode"
    end

    expect(page).to have_button "Check In"
  end

  def create_user_and_event
    @user = create(:user, :eventbrite_authenticated)
    @event = create(:event, user: @user, active: true)
  end
end

