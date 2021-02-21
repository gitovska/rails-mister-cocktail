Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "cocktails#index", as: :cocktails
  post "cocktails", to: "cocktails#create"
  get "cocktails/new", to: "cocktails#new", as: :new_cocktail
  get "cocktails/:id/edit", to: "cocktails#edit", as: :edit_cocktail
  get "cocktails/:id", to: "cocktails#show", as: :cocktail
  patch "cocktails/:id", to: "cocktails#update"
  delete " cocktails/:id", to: "cocktails#destroy"
end
