# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :tasks do
    collection do
      get 'calendar', to: 'tasks#calendar'
    end
  end
  root 'tasks#index'
end
