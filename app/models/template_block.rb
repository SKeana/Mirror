class TemplateBlock < ApplicationRecord
  belongs_to :template

  validates :title, presence: true
  validates :offset_days, :start_minute, :duration_minutes,
            presence: true, numericality: { only_integer: true }
  validate  :positive_duration

  def start_time_str
    format("%02d:%02d", start_minute / 60, start_minute % 60)
  end

  def end_minute
    start_minute + duration_minutes
  end

  def end_time_str
    em = end_minute
    format("%02d:%02d", (em / 60) % 24, em % 60)
  end

  private

  def positive_duration
    return if duration_minutes.blank?
    errors.add(:duration_minutes, "must be greater than zero") if duration_minutes <= 0
  end
end
