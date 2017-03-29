Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'query' => 'query#query'
    end
  end
end
