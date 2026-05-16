class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :destroy, :apply]

  def index
    @templates = Template.order(:name)
  end

  def new
    @template = Template.new(period_type: "weekly")
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to @template, notice: "Template created. Now add blocks."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # The editor: shows the period grid + existing blocks
  def show
  end

  def destroy
    @template.destroy
    redirect_to templates_path, notice: "Template deleted."
  end

  # Stamp this template's blocks onto the period containing the given date
  def apply
    date = parse_date(params[:date]) || Date.current
    created = @template.apply_to(date)
    start = @template.period_start_for(date)
    redirect_to root_path(date: start.iso8601),
                notice: "Applied #{created.size} block(s) from \"#{@template.name}\"."
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:name, :period_type)
  end

  def parse_date(str)
    Date.parse(str) if str.present?
  rescue ArgumentError
    nil
  end
end
