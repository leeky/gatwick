require "rails_helper"

describe CallbacksController do
  describe "#new" do
    context "when no user is currently signed in" do
      it "redirects to the sign in page" do
        get :new

        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "when 'code' parameter exists, and is valid" do
      it "fetches a token from Eventbrite and updates the current user" do
        create_user_and_sign_in
        stub_eventbrite_token_exchange

        expect(EventFetcherJob).to receive(:perform_later).once

        get :new, code: "dummy-token"

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq t("eventbrite_success")
        expect(@user.eventbrite_token).to eq "dummy-access-token"
      end
    end

    context "when no 'code' parameter exists in the request" do
      it "displays an error on the user's dashboard" do
        create_user_and_sign_in
        stub_eventbrite_token_exchange

        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq t("eventbrite_failure")
      end
    end

    context "when 'code' parameter is invalid" do
      it "attempts to fetch a token from Eventbrite, but an error is thrown" do
        create_user_and_sign_in
        stub_eventbrite_token_exchange_failure

        get :new, code: "broken-token"

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq t("eventbrite_failure")
      end
    end
  end

  def create_user_and_sign_in
    @user = create(:user)
    sign_in_as @user
  end

  def stub_eventbrite_token_exchange
    allow_any_instance_of(EventbriteAuthenticator).
      to receive(:exchange_token).
      and_return('dummy-access-token')
  end

  def stub_eventbrite_token_exchange_failure
    allow_any_instance_of(EventbriteAuthenticator).
      to receive(:exchange_token).
      and_return(false)
  end
end
