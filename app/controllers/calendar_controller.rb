class CalendarController < ApplicationController
  def index
    @view = :week
    @date = parse_date(params[:date]) || Date.current
    @week_start = @date - @date.wday
    @today = Date.current

    @label = @week_start.strftime("Week of %A, %b %-d, %Y")
    @prev_url  = root_path(date: (@week_start - 7).iso8601)
    @next_url  = root_path(date: (@week_start + 7).iso8601)
    @today_url = root_path
  end

  def month
    @view = :month
    @date = parse_date(params[:date]) || Date.current
    @month_start = Date.new(@date.year, @date.month, 1)
    @month_end   = @month_start.next_month - 1
    @grid_start  = @month_start - @month_start.wday   # back up to Sunday
    @today = Date.current

    @label = @month_start.strftime("%B %Y")
    @prev_url  = month_path(date: @month_start.prev_month.iso8601)
    @next_url  = month_path(date: @month_start.next_month.iso8601)
    @today_url = month_path
  end

  def year
    @view = :year
    @date = parse_date(params[:date]) || Date.current
    @year = @date.year
    @today = Date.current

    @label = @year.to_s
    @prev_url  = year_path(date: Date.new(@year - 1, 1, 1).iso8601)
    @next_url  = year_path(date: Date.new(@year + 1, 1, 1).iso8601)
    @today_url = year_path
  end

  private

  def parse_date(str)
    Date.parse(str) if str.present?
  rescue ArgumentError
    nil
  end
end
