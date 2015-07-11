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

        get :new, code: "dummy-token"

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq t("callbacks.new.eventbrite_success")
        expect(@user.eventbrite_token).to eq "dummy-access-token"
      end
    end

    context "when no 'code' parameter exists in the request" do
      it "displays an error on the user's dashboard" do
        create_user_and_sign_in
        stub_eventbrite_token_exchange

        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq t("callbacks.new.eventbrite_failure")
      end
    end

    context "when 'code' parameter is invalid" do
      it "attempts to fetch a token from Eventbrite, but an error is thrown" do
        create_user_and_sign_in
        stub_eventbrite_token_exchange_failure

        get :new, code: "broken-token"

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq t("callbacks.new.eventbrite_failure")
      end
    end
  end

  def create_user_and_sign_in
    @user = create(:user)
    sign_in_as @user
  end

  def stub_eventbrite_token_exchange
    stub_request(:post, "https://www.eventbrite.com/oauth/token").
      to_return(
        status: 200,
        body: {
          "token_type": "bearer",
          "access_token": "dummy-access-token"
        }.to_json,
        headers: { "Content-Type": "application/json" }
      )
  end

  def stub_eventbrite_token_exchange_failure
    stub_request(:post, "https://www.eventbrite.com/oauth/token").
      to_return(
        status: 400,
        body: {
          "error_description": "code is invalid or expired",
          "error": "invalid_grant"
        }.to_json,
        headers: { "Content-Type": "application/json" }
      )
  end
end
