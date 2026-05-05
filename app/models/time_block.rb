class TimeBlock < ApplicationRecord
  validates :title, presence: true
  validates :start_at, :end_at, presence: true
  validate  :end_after_start

  # Blocks whose time range overlaps [from, to)
  scope :overlapping, ->(from, to) {
    where("start_at < ? AND end_at > ?", to, from).order(:start_at)
  }

  private

  def end_after_start
    return if start_at.blank? || end_at.blank?
    errors.add(:end_at, "must be after the start time") if end_at <= start_at
  end
end
