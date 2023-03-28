class ThinkMenuController < ApplicationController
  before_action :authenticate_user!

  def interview_yesterday_meal
    @ates = Ate.where(user: current_user).order(created_at: :desc)
  end

  def interview_yesterday_meal_submit
    # フォームから送信された情報を取得する
    yesterday_meal = params[:yesterday_meal]

    # sessionに昨日の食事内容を保存する
    session[:yesterday_meal] = yesterday_meal

    # suggest_today_mealアクションにリダイレクトする
    redirect_to suggest_today_meal_path
  end

  def suggest_today_meal
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: [
            {
              role: "user",
              content: "栄養バランスを考えた上で、昨日ラーメンを食べた方におすすめする今日の食事のアイデアを提供してください"
            }, {
              role: "assistant",
              content: "鶏胸肉のグリル 鶏胸肉は低脂肪で、たんぱく質が豊富なので、ラーメンの後に食べるのにぴったりです。グリルやオーブンで焼いた鶏胸肉に、野菜たっぷりのサラダを添えて食べると、栄養バランスも良く、おいしく食べることができます。"
            },{
              role: "user",
              content: "栄養バランスを考えた上で、昨日チョコレートケーキを食べた方におすすめする今日の食事のアイデアを上記と同じ形式で提供してください。"
            }, {
              role: "assistant",
              content: "カプレーゼサラダ カプレーゼサラダには、トマトからビタミンC、リコピン、カリウムなどが、モッツァレラチーズからはタンパク質やカルシウムが、バジルからはビタミンKやアンチオキシダントが含まれています。これらの栄養素は、昨日のチョコレートケーキで取り過ぎた糖分や脂肪分をバランス良く補うのに役立ちます。"
            },{
              role: "user",
              content: "栄養バランスを考えた上で、昨日#{session[:yesterday_meal]}を食べた方におすすめする今日の食事のアイデアを上記と同じ形式で提供してください。"
            }
          ], # Required.
          temperature: 0.7,
      }
    )
    @suggest_today_meal = response.dig("choices", 0, "message", "content").split
    @ate = Ate.new(name: @suggest_today_meal[0], user: current_user, start_time: Time.zone.now).save
  end

  def re_suggest_today_meal
    @ate = Ate.where(user: current_user).order(created_at: :desc).limit(1)
    @ate[0].destroy
    redirect_to suggest_today_meal_path
  end
end
