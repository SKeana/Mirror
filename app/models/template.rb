class Template < ApplicationRecord
  PERIOD_TYPES = %w[weekly monthly quarterly].freeze

  # Number of days each period type spans (for the editor grid + apply)
  PERIOD_DAYS = { "weekly" => 7, "monthly" => 31, "quarterly" => 92 }.freeze

  has_many :template_blocks, dependent: :destroy
  has_many :template_applications, dependent: :destroy

  validates :name, presence: true
  validates :period_type, inclusion: { in: PERIOD_TYPES }

  def period_days
    PERIOD_DAYS.fetch(period_type, 7)
  end

  # Given a target date, return the date the period should start on.
  def period_start_for(date)
    case period_type
    when "weekly"  then date - date.wday              # back up to Sunday
    when "monthly" then Date.new(date.year, date.month, 1)
    when "quarterly"
      q_first_month = ((date.month - 1) / 3) * 3 + 1
      Date.new(date.year, q_first_month, 1)
    else date
    end
  end

  # Create real TimeBlocks for the period containing `date`, and record
  # that this template now governs that period (so the calendar can show
  # its name in the banner). Re-applying to the same period is idempotent
  # for the application record.
  def apply_to(date)
    start = period_start_for(date)

    template_applications.find_or_create_by!(
      period_type:  period_type,
      period_start: start
    )

    template_blocks.map do |tb|
      day = start + tb.offset_days
      start_at = Time.zone.local(day.year, day.month, day.day) + tb.start_minute.minutes
      TimeBlock.create!(
        title:    tb.title,
        notes:    tb.notes,
        color:    tb.color,
        start_at: start_at,
        end_at:   start_at + tb.duration_minutes.minutes
      )
    end
  end
end
