Rails.application.routes.draw do
  resources :events

  constraints Clearance::Constraints::SignedIn.new do
    root to: "dashboards#show", as: :signed_in_root
    resources :callbacks, only: :new
  end
end
