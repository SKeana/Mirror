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

    range_start = @week_start.beginning_of_day
    range_end   = (@week_start + 7).beginning_of_day
    @blocks_by_day = TimeBlock.overlapping(range_start, range_end).group_by { |b| b.start_at.to_date }
    @applied_templates = applied_templates(@week_start, @week_start + 7)
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

    range_start = @grid_start.beginning_of_day
    range_end   = (@grid_start + 42).beginning_of_day
    @blocks_by_day = TimeBlock.overlapping(range_start, range_end).group_by { |b| b.start_at.to_date }
    @applied_templates = applied_templates(@grid_start, @grid_start + 42)
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

    range_start = Date.new(@year, 1, 1).beginning_of_day
    range_end   = Date.new(@year + 1, 1, 1).beginning_of_day
    @days_with_blocks = TimeBlock
      .overlapping(range_start, range_end)
      .pluck(:start_at).map { |t| t.to_date }.to_set
    @applied_templates = applied_templates(Date.new(@year, 1, 1), Date.new(@year + 1, 1, 1))
  end

  private

  def parse_date(str)
    Date.parse(str) if str.present?
  rescue ArgumentError
    nil
  end

  # Distinct template names whose applied period overlaps [from, to)
  def applied_templates(from, to)
    TemplateApplication.overlapping(from, to)
                       .map { |a| a.template.name }
                       .uniq
  end
end
