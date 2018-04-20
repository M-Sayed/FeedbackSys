Rails.application.routes.draw do
  namespace :api, path: '' do
    post  '/feedbacks'            => 'feedbacks#create'
    get   '/feedbacks'            => 'feedbacks#index'
    get   '/feedbacks/count'      => 'feedbacks#count'
    get   '/feedbacks/:number'    => 'feedbacks#show'
  end
end
