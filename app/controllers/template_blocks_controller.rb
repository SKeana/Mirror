class TemplateBlocksController < ApplicationController
  before_action :set_template
  before_action :set_template_block, only: [:edit, :update, :destroy]

  def new
    @template_block = @template.template_blocks.new(
      offset_days: params[:offset_days].presence || 0,
      start_minute: params[:start_minute].presence || 540,
      duration_minutes: 60,
      color: "#3b82f6"
    )
  end

  def create
    @template_block = @template.template_blocks.new(template_block_params)
    apply_times(@template_block)
    if @template_block.save
      redirect_to @template, notice: "Block added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @template_block.assign_attributes(template_block_params)
    apply_times(@template_block)
    if @template_block.save
      redirect_to @template, notice: "Block updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template_block.destroy
    redirect_to @template, notice: "Block removed."
  end

  private

  def set_template
    @template = Template.find(params[:template_id])
  end

  def set_template_block
    @template_block = @template.template_blocks.find(params[:id])
  end

  def template_block_params
    params.require(:template_block)
          .permit(:title, :notes, :color, :offset_days)
  end

  # Convert the start_time / end_time "HH:MM" fields into the stored
  # start_minute + duration_minutes integers.
  def apply_times(block)
    s = minutes_from(params.dig(:template_block, :start_time))
    e = minutes_from(params.dig(:template_block, :end_time))
    return if s.nil? || e.nil?

    block.start_minute = s
    block.duration_minutes = e > s ? e - s : (24 * 60 - s) + e # wrap past midnight
  end

  def minutes_from(str)
    return nil if str.blank?
    h, m = str.split(":").map(&:to_i)
    h * 60 + m
  end
end
