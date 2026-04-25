class CalendarController < ApplicationController
  def index
    base = parse_date(params[:date]) || Date.current
    @week_start = base - base.wday
    @prev_week = @week_start - 7
    @next_week = @week_start + 7
    @this_week = Date.current - Date.current.wday
  end

  private

  def parse_date(str)
    Date.parse(str) if str.present?
  rescue ArgumentError
    nil
  end
end
