class TemplateApplication < ApplicationRecord
  belongs_to :template

  validates :period_type, presence: true
  validates :period_start, presence: true

  # End date (exclusive) of the period this application covers.
  def period_end
    case period_type
    when "weekly"    then period_start + 7
    when "monthly"   then period_start.next_month
    when "quarterly" then period_start >> 3
    else period_start + 1
    end
  end

  # Applications whose period overlaps the [from, to) date range.
  # Done in Ruby so the per-period-type end-date math stays in one place.
  def self.overlapping(from, to)
    includes(:template).select { |a| a.period_start < to && a.period_end > from }
  end
end
