class TimeBlocksController < ApplicationController
  before_action :set_time_block, only: [:edit, :update, :destroy]

  def new
    @time_block = TimeBlock.new(
      start_at: parse_time(params[:start_at]) || default_start,
      end_at:   parse_time(params[:end_at])   || default_end,
      color:    "#3b82f6"
    )
  end

  def create
    @time_block = TimeBlock.new(time_block_params)
    if @time_block.save
      redirect_to redirect_target(@time_block.start_at.to_date), notice: "Block created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @time_block.update(time_block_params)
      redirect_to redirect_target(@time_block.start_at.to_date), notice: "Block updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    date = @time_block.start_at.to_date
    @time_block.destroy
    redirect_to redirect_target(date), notice: "Block deleted."
  end

  private

  def set_time_block
    @time_block = TimeBlock.find(params[:id])
  end

  def time_block_params
    params.require(:time_block).permit(:title, :notes, :color, :start_at, :end_at)
  end

  def parse_time(str)
    Time.zone.parse(str) if str.present?
  rescue ArgumentError
    nil
  end

  def default_start
    Time.zone.now.change(min: 0)
  end

  def default_end
    default_start + 1.hour
  end

  # Send the user back to the view they came from (default: week of the block)
  def redirect_target(date)
    case params[:return_to]
    when "month" then month_path(date: date.iso8601)
    when "year"  then year_path(date: date.iso8601)
    else              root_path(date: date.iso8601)
    end
  end
end
