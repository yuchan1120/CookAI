Rails.application.routes.draw do
  devise_for :users
  root 'think_menu#interview_yesterday_meal'

  get 'interview_yesterday_meal', to: 'think_menu#interview_yesterday_meal'
  post 'interview_yesterday_meal', to: 'think_menu#interview_yesterday_meal_submit'
  get 'suggest_today_meal', to: 'think_menu#suggest_today_meal'

end
