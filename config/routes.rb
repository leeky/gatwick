Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: "dashboards#show", as: :signed_in_root
    resources :callbacks, only: :new
    resources :events do
      resource :activation, only: [:create]
      resource :deactivation, only: [:create]
    end
  end

  resources :events do
    resource :kiosk, only: [:show]
  end
end
