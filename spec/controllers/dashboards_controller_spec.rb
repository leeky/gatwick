require "rails_helper"

describe DashboardsController do
  describe "#show" do
    context "when no user is currently signed in" do
      it "redirects to the sign in page" do
        get :show

        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "when user has not authenticated with Eventbrite" do
      it "shows the 'Connect to Eventbrite' link" do
        stub_eventbrite_auth_url

        sign_in_as create(:user)
        get :show

        expect(assigns(:eventbrite_auth_url)).to eq dummy_eventbrite_response
      end
    end

    context "when user has authenticated with Eventbrite" do
      it "does not show the 'Connect to Eventbrite' link" do
        stub_eventbrite_auth_url

        sign_in_as create(:user, :eventbrite_authenticated)
        get :show

        expect(assigns(:eventbrite_auth_url)).to be_nil
      end
    end
  end

  def stub_eventbrite_auth_url
    allow(controller).
      to receive(:eventbrite_auth_url).
      and_return(dummy_eventbrite_response)
  end

  def dummy_eventbrite_response
    "https://www.eventbrite.com/oauth/authorize?client_id=XXXXXXXXXXXXXXXXXX"\
    "&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fcallbacks%2Fnew"\
    "&response_type=code"
  end
end
