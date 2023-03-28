Rails.application.routes.draw do
  devise_for :users
  get '/users', to: redirect('/')
  root 'think_menu#interview_yesterday_meal'

  get 'interview_yesterday_meal', to: 'think_menu#interview_yesterday_meal'
  post 'interview_yesterday_meal', to: 'think_menu#interview_yesterday_meal_submit'
  get 'suggest_today_meal', to: 'think_menu#suggest_today_meal'

  delete '/re_suggest_today_meal', to: 'think_menu#re_suggest_today_meal'

  get 'calendar', to: 'calendar#index'
end
