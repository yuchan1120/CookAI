class CalendarController < ApplicationController
  def index
    @ates = current_user.ates
  end
end
